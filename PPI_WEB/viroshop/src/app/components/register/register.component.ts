import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ErrorStateMatcher } from '@angular/material/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { first } from 'rxjs/operators';
import { MessageDialogComponent } from 'src/app/dialog-components/message-dialog/message-dialog.component';
import { AuthenticationService } from 'src/app/services/authentication.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {
  loading = false;
  submitted = false;
  returnUrl: string;
  error: string;

  maxDate = new Date();

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
  email = new FormControl('', [Validators.required, Validators.pattern("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$")]);
  birthDate = new FormControl('', [Validators.required]);
  password = new FormControl('', [Validators.required]);
  password2 = new FormControl('', (formControl) => {return this.password.value != formControl.value ? {equals: 'Wpisz zgodne ze sobą hasła'} : null});
 
  invalidErrorMatcher = new class implements ErrorStateMatcher {
    isErrorState(control, _form): boolean {
      return !!(control && control.invalid && (control.dirty || control.touched))
    }
  }

  pass2ErrorMatcher = new class implements ErrorStateMatcher {
    isErrorState(control, _form): boolean {
      return control && control.invalid && control.hasError("equals");
    }
  }

  ngOnInit() {
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
  }

  register() {
    const request = {
      login: this.username.value,
      email: this.email.value,
      birthDate: this.birthDate.value,
      password: this.password.value
    }

    this.loading = true;
    this.authenticationService.register(request)
      .pipe(first())
      .subscribe(
        data => {
          this.loading = false;
          const dialogRef = this.openDialog("Rejestracja", this.translate.instant("REGISTER."+data), "Zamknij");
          dialogRef.afterClosed().subscribe(_ => this.router.navigate(['/']));
        },
        error => {
          this.loading = false;
          var message = ''
          if (error.statusText != "OK") {
            message = this.translate.instant(error.statusText);
          } else {
            message = this.translate.instant("REGISTER."+error.error);
          }
          this.openDialog("Rejestracja", message, "Zamknij");
        });
  }

  validateForm(formControls) {
    formControls.forEach(element => {
      element.updateValueAndValidity();
    });
  }
  
  openDialog(title, message, close){
    return this.dialog.open(MessageDialogComponent, {
      data: {title: title, message: message, close: close},
      panelClass: 'message-panel'
    });
  }
}
