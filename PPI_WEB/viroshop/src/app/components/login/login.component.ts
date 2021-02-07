import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { first } from 'rxjs/operators';
import { MessageDialogComponent } from 'src/app/dialog-components/message-dialog/message-dialog.component';
import { AuthenticationService } from 'src/app/services/authentication.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  loading = false;
  submitted = false;
  returnUrl: string;

  constructor(
      private route: ActivatedRoute,
      private router: Router,
      private authenticationService: AuthenticationService,
      private translate: TranslateService,
      private dialog: MatDialog
  ) {
    if (this.authenticationService.currentUserValue) { 
      this.router.navigate(['/']);
    }
  }

  username = new FormControl('', [Validators.required]);
  password = new FormControl('', [Validators.required]);
 
  ngOnInit() {
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
  }

  login() {
    this.submitted = true;

    this.loading = true;
    this.authenticationService.login(this.username.value, this.password.value)
     .pipe(first())
      .subscribe(
        data => {
          this.loading = false;
          this.router.navigate([this.returnUrl]);
        },
        error => {
          this.loading = false;
          var message=''
          if (error.statusText != "OK") {
            message = this.translate.instant(error.statusText);
          } else {
            message = this.translate.instant("LOGIN."+error.error);
          }
          this.openDialog("Logowanie", message, "Zamknij");
        });
  }

  forgot() {
    this.submitted = true;
    
    this.loading = true;
    this.authenticationService.forgorPassword(this.username.value)
     .pipe(first())
      .subscribe(
        data => {
          this.loading = false;
          this.openDialog("Przypomnij hasło", this.translate.instant("FORGOT."+data), "Zamknij");
        },
        error => {
          this.loading = false;
          var message = ''
          if (error.statusText != "OK") {
            message = this.translate.instant(error.statusText);
          } else {
            message = this.translate.instant("FORGOT."+error.error);
          }
          this.openDialog("Przypomnij hasło", message, "Zamknij");
        });
  }

  openDialog(title, message, close){
    this.dialog.open(MessageDialogComponent, {
      data: {title: title, message: message, close: close},
      panelClass: 'message-panel'
    });
  }
}
