import { Component, OnInit } from '@angular/core';
import { FormControl, Validators } from '@angular/forms';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { TranslateService } from '@ngx-translate/core';
import { first } from 'rxjs/operators';
import { AuthenticationService } from 'src/app/services/authentication.service';
import { MessageDialogComponent } from '../message-dialog/message-dialog.component';

@Component({
  selector: 'app-change-password-dialog',
  templateUrl: './change-password-dialog.component.html',
  styleUrls: ['./change-password-dialog.component.scss']
})
export class ChangePasswordDialogComponent implements OnInit {

  loading = false;
  oldPassword = new FormControl('', [Validators.required]);
  newPassword = new FormControl('', [Validators.required]);
  
  error = '';

  constructor(
    private dialogRef: MatDialogRef<ChangePasswordDialogComponent>,
    private authenticationService: AuthenticationService,
    private dialog: MatDialog,
    private translate: TranslateService
  ) {}

  ngOnInit(): void {
  }

  onChange(): void {
    const requestBody = {
      login: this.authenticationService.currentUserValue,
      oldPassword: this.oldPassword.value,
      newPassword: this.newPassword.value
    }
    this.loading = true;
    this.authenticationService.changePassword(requestBody)
     .pipe(first())
      .subscribe(
        data => {
          this.loading = false;
          this.dialogRef.close();
          this.openDialog("Zmiana hasła", "Hasło zmieniono pomyślnie", "Zamknij");
        },
        error => {
          this.loading = false;
          if (error.statusText != "OK") {
            this.error = this.translate.instant(error.statusText);
          } else {
            this.error = this.translate.instant("CHANGE_PASSWORD."+error.error);
          }
        });
  }

  onCancel() {
    this.dialogRef.close();
  }

  openDialog(title, message, close){
    this.dialog.open(MessageDialogComponent, {
      data: {title: title, message: message, close: close},
      panelClass: 'message-panel'
    });
  }

}
