import { ModuleWithProviders } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
//import { LayoutComponent } from './layout/layout.component';
import { ShopListComponent } from './components/shop-list/shop-list.component';
import { ProductListComponent } from './components/product-list/product-list.component';
import { CartComponent } from './components/cart/cart.component';
import { LoginComponent } from './components/login/login.component';
import { RegisterComponent } from './components/register/register.component';
import { AuthGuardService } from './services/auth-guard.service';
import { ReservationsComponent } from './components/reservations/reservations.component';

export const appRoutes: Routes = [
  {
    path: 'login',
    component: LoginComponent
  },
  {
    path: 'register',
    component: RegisterComponent
  },
  {
    path: '',
    pathMatch: 'full',
    redirectTo: '/shops'
  },
  {
    path: 'shops',
    component: ShopListComponent,
    canActivate: [AuthGuardService]
  },
  {
    path: ':shop/products',
    component: ProductListComponent,
    canActivate: [AuthGuardService]
  },
  {
    path: 'cart',
    component: CartComponent,
    canActivate: [AuthGuardService]
  },
  {
    path: 'cart/:shop',
    component: CartComponent,
    canActivate: [AuthGuardService]
  },
  {
    path: 'reservations',
    component: ReservationsComponent,
    canActivate: [AuthGuardService]
  }
];

export const routing = RouterModule.forRoot(appRoutes);
