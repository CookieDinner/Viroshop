import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { ShopListComponent } from './components/shop-list/shop-list.component';
import { ProductListComponent } from './components/product-list/product-list.component';
import { CartComponent } from './components/cart/cart.component';
import { LoginComponent } from './components/login/login.component';
import { MatTableModule } from '@angular/material/table';
import { MatPaginatorIntl, MatPaginatorModule } from '@angular/material/paginator';
import { MatSortModule } from '@angular/material/sort';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { routing } from './app.routes';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatListModule } from '@angular/material/list';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { RegisterComponent } from './components/register/register.component';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatNativeDateModule, MAT_DATE_LOCALE } from '@angular/material/core';
import { ChangePasswordDialogComponent } from './dialog-components/change-password-dialog/change-password-dialog.component';
import { MatDialogModule } from '@angular/material/dialog';
import { MatSelectModule } from '@angular/material/select';
import { TranslateLoader, TranslateModule } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { OrderProductsDialogComponent } from './dialog-components/order-products-dialog/order-products-dialog.component';
import { MessageDialogComponent } from './dialog-components/message-dialog/message-dialog.component';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { SpinnerDialogComponent } from './dialog-components/spinner-dialog/spinner-dialog.component';
import { ReservationDialogComponent } from './dialog-components/reservation-dialog/reservation-dialog.component';
import { MatStepperModule } from '@angular/material/stepper';
import { PictureDialogComponent } from './dialog-components/picture-dialog/picture-dialog.component';
import { ReservationsComponent } from './components/reservations/reservations.component';
import { EmptyContentComponent } from './components/empty-content/empty-content.component';
import { MatTabsModule } from '@angular/material/tabs';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { LastAddedSnackbarComponent } from './components/product-list/last-added-snackbar/last-added-snackbar.component';
import { MatExpansionModule } from '@angular/material/expansion';
import { ProductListOnReservationComponent } from './components/reservations/product-list-on-reservation/product-list-on-reservation.component';
import { MatButtonToggleModule } from '@angular/material/button-toggle';

@NgModule({
  declarations: [
    AppComponent,
    ShopListComponent,
    ProductListComponent,
    CartComponent,
    LoginComponent,
    RegisterComponent,
    ChangePasswordDialogComponent,
    OrderProductsDialogComponent,
    MessageDialogComponent,
    SpinnerDialogComponent,
    ReservationDialogComponent,
    PictureDialogComponent,
    ReservationsComponent,
    EmptyContentComponent,
    LastAddedSnackbarComponent,
    ProductListOnReservationComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    MatTableModule,
    MatPaginatorModule,
    MatSortModule,
    MatButtonModule,
    MatIconModule,
    MatInputModule,
    FormsModule,
    MatListModule,
    MatToolbarModule,
    MatSidenavModule,
    MatCheckboxModule,
    HttpClientModule,
    ReactiveFormsModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatDialogModule,
    MatSelectModule,
    MatProgressSpinnerModule,
    MatStepperModule,
    MatTabsModule,
    MatSnackBarModule,
    MatExpansionModule,
    MatButtonToggleModule,
    TranslateModule.forRoot({
      loader: { provide: TranslateLoader, useClass: TranslateHttpLoader, deps: [HttpClient] },
      defaultLanguage: 'pl'
    }),
    routing
  ],
  providers: [
    { provide: MatPaginatorIntl, useValue: getPlPaginatorIntl() },
    { provide: MAT_DATE_LOCALE, useValue: 'pl'}
  ]
,
  bootstrap: [AppComponent]
})
export class AppModule { }

function getPlPaginatorIntl() {
  const paginatorIntl = new MatPaginatorIntl();
  
  paginatorIntl.itemsPerPageLabel = 'Elementów na stronie:';
  paginatorIntl.nextPageLabel = 'Następna strona';
  paginatorIntl.previousPageLabel = 'Poprzednia strona';
  paginatorIntl.getRangeLabel = ((page, pageSize, length) => {
    const startElement = page * pageSize + 1 > length ? length : page * pageSize + 1;
    const endElement = (page+1) * pageSize > length ? length : (page+1)*pageSize;
    return startElement.toString() + '-' + endElement.toString() + ' z ' + length.toString();
  });
  
  return paginatorIntl;
}