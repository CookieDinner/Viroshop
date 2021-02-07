import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import * as moment from 'moment';
import { first } from 'rxjs/operators';
import { AuthenticationService } from 'src/app/services/authentication.service';
import { ConnectionService } from 'src/app/services/connection.service';
import { MessageDialogComponent } from '../message-dialog/message-dialog.component';

@Component({
  selector: 'app-reservation-dialog',
  templateUrl: './reservation-dialog.component.html',
  styleUrls: ['./reservation-dialog.component.scss']
})
export class ReservationDialogComponent implements OnInit {

  step = 0;
  selectedMomentDate = moment();
  selectedMomentTime = moment().hour(7).minute(0);
  selectedDate = new Date();
  selectedTime = [0];
  startAt = new Date();
  minDate = new Date();
  year: any;
  dayAndDate: string;
  reservationAtDate = {}
  private _maxReservationForQuarter;
  loading = false;
  times = [];

  constructor(
    public dialogRef: MatDialogRef<ReservationDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private connectionService: ConnectionService,
    private authenticationService: AuthenticationService,
    private dialog: MatDialog,
    private changeDetectorRef: ChangeDetectorRef
  ) { }

  ngOnInit(): void {
    this._maxReservationForQuarter = this.data.shop.maxReservationsPerQuarterOfHour;
  }

  dateViewOpen() {
    document.querySelector('.mat-calendar-previous-button').addEventListener('click', () => this.monthViewChanged());
    document.querySelector('.mat-calendar-next-button').addEventListener('click', () => this.monthViewChanged());
    this.monthViewChanged();
    this.dateSelected(new Date());
  }

  ngAfterViewInit() {
    this.dateViewOpen();
    this.setTimesTable();
  }

  setTimesTable() {
    const m = moment(this.selectedDate).hour(7).minute(0);
    this.selectedTime = [0];
    this.times = [];
    for (var i=0; i<16*4; i++) {
      this.times.push({
        time: m.format("HH:mm"),
        quarter: i,
        disabled: m.isBefore(moment())
      });
      if (m.isBefore(moment())) {
        this.selectedTime=[i+1];
      }
      m.add(15, 'm');
    }
    if (m.isBefore(moment())) {
      this.selectedMomentDate.add(1, 'day');
      this.selectedTime = [0];
    }
    this.selectedMomentTime = moment().hour(7).minute(0).add(this.selectedTime[0]*15, 'm');
    this.changeDetectorRef.detectChanges();
  }

  dateSelected(event) {
    this.selectedMomentDate = moment(event);
    this.step = 1;
    this.selectedDate = event;
    this.loading = true;
    this.setTimesTable();
    this.connectionService.getReservationInDay(
      this.data.shop.id,
      moment(event).format("yyyy-MM-DD")
    ).pipe(first()).subscribe(
      result => {
        result.forEach(quarter => {
          var element = document.querySelector('[ng-reflect-value="'+quarter.quarter+'"]');
          
          if (element.getAttribute('aria-disabled')=="false") {
            if (quarter.count < this._maxReservationForQuarter * (1/4)) {
              element.classList.add("below_25");
            } else if (quarter.count < this._maxReservationForQuarter * (2/4)) {
              element.classList.add("below_50");
            } else if (quarter.count < this._maxReservationForQuarter * (3/4)) {
              element.classList.add("below_75");
            } else if (quarter.count < this._maxReservationForQuarter * (4/4)) {
              element.classList.add("below_100");
            } else {
              element.classList.add('mat-list-item', 'mat-list-option', 'mat-focus-indicator', 'mat-list-item-disabled', 'mat-accent', 'ng-star-inserted')
            }
          }
        });
        this.loading = false;
      }
    )
  }

  timeSelected(event) {
    this.selectedTime = event.options[0] ? [event.options[0].value] : [0];
    this.selectedMomentTime = moment().hour(7).minute(0).add(this.selectedTime[0]*15, 'm');
  }

  monthViewChanged(event?) {
    var activeDate;
    var activeMoment;

    if (event) {
      activeDate = event;
      activeMoment = moment(event);
    } else {
      activeDate = document.querySelector('mat-month-view').getAttribute('ng-reflect-active-date');
      activeMoment = moment(activeDate);
    }

    this.loading = true;
    this.connectionService.getReservationInMonth(
      this.data.shop.id,
      activeMoment.month()+1,
      activeMoment.year()
    ).pipe(first()).subscribe(
      result => {
        result.forEach(element => {
          this.reservationAtDate[element.date]=element.count;
        });
        this._colorCalendar(activeDate);
        this.loading = false;
      }
    );
  }

  private _colorCalendar(date) {
    const orgM = moment(date);
    var m = moment(date).date(1)
    while (m.month() == orgM.month()) {
      var element = document.querySelector('[aria-label="'+m.locale('pl').format("D MMMM YYYY")+'"]');
      if (!m.isAfter(moment())) {
        m.add(1, 'd');
        continue;
      } else if (!this.reservationAtDate[m.format("YYYY-MM-DD")]) {
        element.classList.add("below_unknown");
      } else if (this.reservationAtDate[m.format("YYYY-MM-DD")] < this._maxReservationForQuarter * 4 * 16 * (1/4)) {
        element.classList.add("below_25");
      } else if (this.reservationAtDate[m.format("YYYY-MM-DD")] < this._maxReservationForQuarter * 4 * 16 * (2/4)) {
        element.classList.add("below_50");
      } else if (this.reservationAtDate[m.format("YYYY-MM-DD")] < this._maxReservationForQuarter * 4 * 16 * (3/4)) {
        element.classList.add("below_75");
      } else {
        element.classList.add("below_100");
      }
      m.add(1, 'd');
    }

  }

  reserveTime() {
    const requestDatePart = {
      date: this.selectedMomentDate.format("YYYY-MM-DD"),
      quarterOfDay: this.selectedTime[0],
    };
    this._reserve(requestDatePart);    
  }

  reserveNoTime() {
    const requestDatePart = {
      date: null,
      quarterOfDay: 0,
    };
    this._reserve(requestDatePart);
  }

  private _reserve(dateObj) {
    dateObj["shopId"] = this.data.shop.id;
    dateObj["productReservations"] = [];
    this.data.products.forEach(product => {
      dateObj["productReservations"].push({ productId: product.id, count: product.count });
    });
    dateObj["login"] = this.authenticationService.currentUserValue;
    this.connectionService.createNewReservation(dateObj).subscribe(
      result => {
        if (result == null) {
          this.openDialog("Rezerwacja", "Nie udało się dokonanać rezerwacji", "Zamknij");
        } else {
          this.dialogRef.close("success");
          this.openDialog("Rezerwacja", "Dokonano rezerwacji", "Zamknij");
        }
      }
    );
  }

  openDialog(title, message, close){
    this.dialog.open(MessageDialogComponent, {
      data: {title: title, message: message, close: close},
      panelClass: 'message-panel'
    });
  }
}
