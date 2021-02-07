import { Component, Input, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { PictureDialogComponent } from 'src/app/dialog-components/picture-dialog/picture-dialog.component';

@Component({
  selector: 'app-product-list-on-reservation',
  templateUrl: './product-list-on-reservation.component.html',
  styleUrls: ['./product-list-on-reservation.component.scss']
})
export class ProductListOnReservationComponent {

  @Input() dataSource: Array<any>;
  displayedColumns = ["photo", "name", "type", "price"];

  constructor(
    private dialog: MatDialog
  ) { }

  openPictureDialog(source) {
    this.dialog.open(PictureDialogComponent, {
      data: source
    });
  }
}
