import { Injectable } from '@angular/core';
import { forkJoin, from, Observable, of, Subject } from 'rxjs';
import { filter, first } from 'rxjs/operators';
import { AuthenticationService } from './authentication.service';
import { ConnectionService } from './connection.service';

@Injectable({
  providedIn: 'root'
})
export class CartService {

  constructor(
    private authenticationService: AuthenticationService,
    private connectionService: ConnectionService
  ) { }

  addProduct(shopId, product) {
    const user = this.authenticationService.currentUserValue;
    const localStorageName = 'cart_'+user;
    const localCart = localStorage.getItem(localStorageName);
    const cart = localCart ? JSON.parse(localCart) : {};
    if (cart[shopId]) {
      if (cart[shopId][product.id]) {
        cart[shopId][product.id] += product.count;
      } else {
        cart[shopId][product.id] = product.count;
      }
    } else {
      cart[shopId] = {};
      cart[shopId][product.id] = product.count;
    }
    localStorage.setItem(localStorageName, JSON.stringify(cart));
  }

  removeOneProduct(shopId, product) {
    const user = this.authenticationService.currentUserValue;
    const localStorageName = 'cart_'+user;
    const localCart = localStorage.getItem(localStorageName);
    const cart = localCart ? JSON.parse(localCart) : {};
    if (cart[shopId]) {
      if (cart[shopId][product.id]) {
        if (cart[shopId][product.id] > 1) {
          cart[shopId][product.id] -= 1;
        } else {
          delete cart[shopId][product.id];
        }
      }
      if (Object.keys(cart[shopId]).length == 0) {
        delete cart[shopId];
      }
    }
    localStorage.setItem(localStorageName, JSON.stringify(cart));
  }

  addOneProduct(shopId, product) {
    const user = this.authenticationService.currentUserValue;
    const localStorageName = 'cart_'+user;
    const localCart = localStorage.getItem(localStorageName);
    const cart = localCart ? JSON.parse(localCart) : {};
    if (cart[shopId]) {
      if (cart[shopId][product.id]) {
        cart[shopId][product.id] += 1;
      } else {
        cart[shopId][product.id] = 1;
      }
    } else {
      cart[shopId] = {};
      cart[shopId][product.id] = 1;
    }
    localStorage.setItem(localStorageName, JSON.stringify(cart));
  }


  removeWholeProduct(shopId, product) {
    const user = this.authenticationService.currentUserValue;
    const localStorageName = 'cart_'+user;
    const localCart = localStorage.getItem(localStorageName);
    const cart = localCart ? JSON.parse(localCart) : {};
    if (cart[shopId]) {
      if (cart[shopId][product.id]) {
        delete cart[shopId][product.id];
      }
      if (Object.keys(cart[shopId]).length == 0) {
        delete cart[shopId];
      }
    }
    localStorage.setItem(localStorageName, JSON.stringify(cart));
  }

  getCart(shopId?): Observable<any> | Array<any> {
    const sub = new Subject<any>();
    const user = this.authenticationService.currentUserValue;
    const userCart = localStorage.getItem('cart_'+user) ? JSON.parse(localStorage.getItem('cart_'+user)) : {};
    const cart = [];
    const shopsProductsForForkJoin = [];

    if (shopId == null) {
      Object.keys(userCart).forEach(shopKey => {
        shopsProductsForForkJoin.push(this.connectionService.getShopWithProducts(shopKey).pipe(first()));
      });
    } else {
      shopsProductsForForkJoin.push(this.connectionService.getShopWithProducts(shopId).pipe(first()));
    }

    if (shopsProductsForForkJoin.length == 0) {
      return [];
    } else {
      forkJoin(shopsProductsForForkJoin).pipe(first()).subscribe(
        shopsProductsArray => {
          shopsProductsArray.forEach(objectShopProducts => {
            const shop = objectShopProducts['shop'];
            const products = objectShopProducts['products'];
            const userCartShop = userCart[shop['id']];
            const subcart = {shop: null, products: null};
            subcart.shop = shop;
            if (userCartShop != null) {
              subcart.products = products
                .map(product => {
                  if (Object.keys(userCartShop).includes(product.id.toString())) {
                    product.count = userCartShop[product.id];
                    return product;
                  } else {
                    return null;
                  }})
                .filter(element => element != null);
              if (subcart.products.length != 0) {
                cart.push(subcart);
              }    
            }
          });
          sub.next(cart);
          sub.complete();
      });
    }
    return sub;
  }

  removeCart(shopId) {
    const user = this.authenticationService.currentUserValue;
    const userCart = localStorage.getItem('cart_'+user) ? JSON.parse(localStorage.getItem('cart_'+user)) : {};
    delete userCart[shopId];
    localStorage.setItem('cart_'+user, JSON.stringify(userCart));
  }

}
