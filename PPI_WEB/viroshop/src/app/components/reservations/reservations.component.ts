import { ArrayDataSource } from '@angular/cdk/collections';
import { Component, OnInit } from '@angular/core';
import { resetFakeAsyncZone } from '@angular/core/testing';
import * as moment from 'moment';
import { forkJoin } from 'rxjs';
import { first } from 'rxjs/operators';
import { AuthenticationService } from 'src/app/services/authentication.service';
import { ConnectionService } from 'src/app/services/connection.service';

@Component({
  selector: 'app-reservations',
  templateUrl: './reservations.component.html',
  styleUrls: ['./reservations.component.scss']
})
export class ReservationsComponent implements OnInit {

  archivedReservations = [];
  futureReservations = [];
  noDateReservations = [];
  loading = false;

  actualShow = "future";

  constructor(
    private connectionService: ConnectionService,
    private authenticationService: AuthenticationService
  ) { }

  ngOnInit(): void {
    const shopsWithProductsObject = {}

    this.loading = true;

    const username = this.authenticationService.currentUserValue;
    this.connectionService.getAllUserReservations(username).subscribe(
      result => {
        const shopsProductsForForkJoin = [];
        const shopIds = new Set();
        (<Array<any>> result).forEach(reservation => {
          shopIds.add(reservation.shop);
        });

        shopIds.forEach(shopId => {
          shopsProductsForForkJoin.push(this.connectionService.getShopWithProducts(shopId).pipe(first()));
        });
    
        forkJoin(shopsProductsForForkJoin).pipe(first()).subscribe(
          shopsProductsArray => {
            shopsProductsArray.forEach(shopProducts => {
              shopProducts['shop']['products'] = {};
              shopProducts['products'].forEach(product => {
                shopProducts['shop']['products'][product['id']] = product;
              });
              delete shopProducts['products'];
              shopsWithProductsObject[shopProducts['shop']['id']] = shopProducts;
            });

            const now = moment();
            
            (<Array<any>> result).forEach(reservation => {
              var totalPrice = 0.0;
              reservation['shop'] = shopsWithProductsObject[reservation['shop']].shop;
              reservation['productReservations'] = reservation['productReservations'].map(product => {
                const newProduct = {
                  ...product,
                  ...reservation['shop']['products'][product.product]
                };

                totalPrice += newProduct.count * newProduct.price;
                return newProduct;
              });
              reservation['totalPrice'] = totalPrice;
              if (reservation.date == null) {
                this.noDateReservations.push(reservation);
              } else if (now.isBefore(moment(reservation.date).hour(7).minute(0).add(reservation.quarterOfDay*15, 'm'))) {
                this.futureReservations.push(reservation);
              } else {
                this.archivedReservations.push(reservation);
              }
              this.loading = false;
            });
            
            this.futureReservations.sort((a, b) => {
              const aMoment = moment(a.date).hour(7).minute(0).add(a.quarterOfDay*15, 'm');
              const bMoment = moment(b.date).hour(7).minute(0).add(b.quarterOfDay*15, 'm');
              return aMoment.isBefore(bMoment) ? -1 : aMoment.isAfter(bMoment) ? 1 : 0;
            });

            this.archivedReservations.sort((a, b) => {
              const aMoment = moment(a.date).hour(7).minute(0).add(a.quarterOfDay*15, 'm');
              const bMoment = moment(b.date).hour(7).minute(0).add(b.quarterOfDay*15, 'm');
              return aMoment.isBefore(bMoment) ? 1 : aMoment.isAfter(bMoment) ? -1 : 0;
            });

          },
          error => {
            this.loading = false;
          }
        );
      },
      error => {
        this.loading = false;
      }
    )
  }

  getTime(date, quarter) {
    return moment(date).hour(7).minute(0).add(quarter*15, 'm').format("yyyy-MM-DD HH:mm");
  }
}
