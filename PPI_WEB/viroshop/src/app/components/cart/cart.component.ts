import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
import { isObservable, Observable } from 'rxjs';
import { first, take } from 'rxjs/operators';
import { MessageDialogComponent } from 'src/app/dialog-components/message-dialog/message-dialog.component';
import { OrderProductsDialogComponent } from 'src/app/dialog-components/order-products-dialog/order-products-dialog.component';
import { ReservationDialogComponent } from 'src/app/dialog-components/reservation-dialog/reservation-dialog.component';
import { CartService } from 'src/app/services/cart.service';

@Component({
  selector: 'app-cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.scss']
})
export class CartComponent implements OnInit {
  
  constructor(
    private cartService: CartService,
    private route: ActivatedRoute,
    private dialog: MatDialog
  ) { }

  cart = null;
  shopId;
  displayedColumns: string[] = ['select', 'name', 'type', 'actions', 'onePrice', 'price'];

  ngOnInit(): void {
    this.shopId = this.route.snapshot.paramMap.get('shop');
    this.refreshCart();
  }

  decrease(shopId, product) {
    this.cartService.removeOneProduct(shopId, product);
    product.count -= 1;
    if (product.count == 0) {
      this.refreshCart();
    }
  }

  increase(shopId, product) {
    this.cartService.addOneProduct(shopId, product);
    product.count += 1;
  }

  removeFromCart(shopId, product) {
    this.cartService.removeWholeProduct(shopId, product);
    this.refreshCart();
  }

  refreshCart() {
    const cartResult = this.cartService.getCart(this.shopId);
    if (isObservable(cartResult)) {
      (<Observable<any>>cartResult).pipe(first()).subscribe(
        data=> {
          data.forEach(shop => {
            shop['products'].forEach(element => {
              if (element.canBePurchaseToParcelLocker) {
                element['way'] = 'shopMachine';
              } else {
                element['way'] = 'reservation';
              }
            });
          });
        this.cart = data;
      }
      );
    } else {
      this.cart = cartResult;
    }
  }

  totalPrice(cart) {
    var totalPrice = 0.0;
    cart.products.forEach(element => {
      totalPrice += element.count * element.price;
    });
    return totalPrice;
  }

  canOrder(cart) {
    for (var i=0; i<cart.products.length; i++) {
      if (cart.products[i].way == 'shopMachine')
      return true;
    }
    return false;
  }

  canReserve(cart) {
    for (var i=0; i<cart.products.length; i++) {
      if (cart.products[i].way == 'reservation')
      return true;
    }
    return false;
  }

  order(cart){
    const dialogRef = this.dialog.open(OrderProductsDialogComponent, {
      width: '400px',
      panelClass: 'zbik-panel'
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result == 'success') {
        cart.products.forEach(product => {
          if (product.way == 'shopMachine') {
            this.cartService.removeWholeProduct(cart.shop.id, product);
          }
        });
        this.refreshCart();
      }
    });
  }

  book(cart){
    const dialogRef = this.dialog.open(ReservationDialogComponent, {
      data: cart,
      width: '400px',
      height: '600px'
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result == 'success') {
        cart.products.forEach(product => {
          if (product.way == 'reservation') {
            this.cartService.removeWholeProduct(cart.shop.id, product);
          }
        });
        this.refreshCart();
      } else if (result == 'failed') {

      }
    });
  }
}
