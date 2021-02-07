import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, combineLatest, forkJoin } from 'rxjs';
import { first } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class ConnectionService {

  api="http://localhost:8080/api/";
  favouriteShopUrl = this.api + "shops/favourites";
  shopsUrl = this.api+"shops";
  shopUrl = this.api+"shop?id="
  productsShopUrl = this.api + "data/products/basic?shopId=";
  productUrl = this.api + "data/product?id=";
  productsFullUrl = this.api + "data/products/full";
  productsBasicUrl = this.api + "data/products/basic";
  reservationDayUrl = this.api + "reservation/count/day";
  reservationMonthUrl = this.api + "reservation/count/month";
  resrvationNew = this.api + "reservation/new";
  reservationCancel = this.api + "";
  reservationUser = this.api + "reservation/all";

  constructor(
    private httpClient: HttpClient
  ) { }

  public getShops(): Observable<any> {
    return this.httpClient.get(this.shopsUrl);
  }

  public getShopsWithFavourites(username): Observable<any> {
    return forkJoin({
      shops: this.httpClient.get(this.shopsUrl).pipe(first()),
      favourites: this.httpClient.get(this.favouriteShopUrl, {params: {login: username}}).pipe(first())
    });
  }

  public getShop(shopId): Observable<any> {
    return this.httpClient.get(this.shopUrl + shopId.toString());
  }

  public getProduct(productId): Observable<any> {
    return this.httpClient.get(this.productUrl + productId.toString());
  }

  public getProducts(shopId: String): Observable<any> {
    return this.httpClient.get(this.productsShopUrl+shopId);
  }

  public getShopWithProducts(shopId): Observable<any> {
    return forkJoin({
      shop: this.httpClient.get(this.shopUrl + shopId.toString()).pipe(first()),
      products: this.httpClient.get(this.productsShopUrl+shopId).pipe(first())
    });
  }

  public changeFavourite(shopId, shopFavourite, username) {
    if (shopFavourite) {
      this._removeFromFavourite(shopId, username);
    } else {
      this._addToFavourite(shopId, username);
    }
  }

  private _removeFromFavourite(shopId, username) {
    this.httpClient.delete(
      this.favouriteShopUrl,
      {
        responseType: 'text',
        params: new HttpParams().append("shopId", shopId).append("login", username)
      }
    ).pipe(first()).subscribe();
  }

  private _addToFavourite(shopId, username) {
    this.httpClient.post(
      this.favouriteShopUrl,
      null,
      {
        responseType: 'text',
        params: new HttpParams().append("shopId", shopId).append("login", username)
      }
    ).pipe(first()).subscribe();
  }

  getReservationInMonth(shopId, month, year): Observable<any>{
    return this.httpClient.get(
      this.reservationMonthUrl,
      {
        params: new HttpParams().append("shopId", shopId).append("month", month).append("year", year)
      }
    )
  }

  getReservationInDay(shopId, date): Observable<any> {
    return this.httpClient.get(
      this.reservationDayUrl,
      {
        params: new HttpParams().append("shopId", shopId).append("date", date)
      }
    )
  }

  createNewReservation(requestBody) {
    return this.httpClient.post(
      this.resrvationNew,
      requestBody
    )
  }

  getAllUserReservations(userLogin) {
    return this.httpClient.get(
      this.reservationUser,
      {
        params: new HttpParams().append("login", userLogin)
      }
    )
  }

}
