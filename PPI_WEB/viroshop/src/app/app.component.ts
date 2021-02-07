import { MediaMatcher } from '@angular/cdk/layout';
import { ChangeDetectorRef, Component } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { ChangePasswordDialogComponent } from './dialog-components/change-password-dialog/change-password-dialog.component';
import { AuthenticationService } from './services/authentication.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  currentUser: any;

  constructor(
      private authenticationService: AuthenticationService,
      private dialog: MatDialog,
      private translate: TranslateService,
      private router: Router
  ) {
    this.authenticationService.currentUserSubject.subscribe(x => this.currentUser = x);
    this.translate.setDefaultLang('pl');
    this.translate.use('pl');
  }

  openChangePasswordDialog(): void {
    const dialogRef = this.dialog.open(ChangePasswordDialogComponent, {
      width: '400px'
    });
  }

  logoutUser() {
    this.authenticationService.logout();
    this.router.navigate(['/login']);
  }
  
  title = 'viroshop-web';

}
