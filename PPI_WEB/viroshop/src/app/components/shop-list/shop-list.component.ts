import { Component, OnInit, ViewChild } from '@angular/core';
import { ConnectionService } from 'src/app/services/connection.service';
import { first } from 'rxjs/operators';
import { Router } from '@angular/router';
import { MatPaginator } from '@angular/material/paginator';
import { MatTableDataSource } from '@angular/material/table';
import { AuthenticationService } from 'src/app/services/authentication.service';

@Component({
  selector: 'app-shop-list',
  templateUrl: './shop-list.component.html',
  styleUrls: ['./shop-list.component.scss']
})
export class ShopListComponent implements OnInit {

  loading = false;
  filteredShopList = new MatTableDataSource<any>();
  shopList = [];
  cities = new Set();
  selectedCity = null;
  selectedShop = '';
  selectedStreet = '';
  selectedFavourite = false;

  displayedColumns: string[] = ['shop', 'products', 'cart', 'favourite'];

  @ViewChild(MatPaginator) paginator: MatPaginator;

  constructor(
    private connectionService: ConnectionService,
    private router: Router,
    private authenticationService: AuthenticationService
  ) { }

  ngOnInit(): void {
    this.loading = true;
    const username = this.authenticationService.currentUserValue;
    this.connectionService.getShopsWithFavourites(username).pipe(first()).subscribe(
      result => {
        const favIds = [];
        result.favourites.forEach(element => {
          favIds.push(element.id);
        });
        this.shopList = result.shops.map(shop => {shop.favourite = favIds.includes(shop.id); return shop;});
        this.filterShops();
        this.cities = new Set();
        result.shops.forEach(element => {
          this.cities.add(element.city)
        });
        this.loading = false;
      },
      error => {
        this.loading = false;
      }
    )
  }

  ngAfterViewInit() {
    this.filteredShopList.paginator = this.paginator;
  }

  filterShops() {
    this.filteredShopList.data = this.shopList.filter(shop => {
      return this.selectedCity == null || shop.city == this.selectedCity;
    }).filter(shop => {
      return this.selectedShop == null || shop.name.toLowerCase().includes(this.selectedShop.toLowerCase());
    }).filter(shop => {
      return this.selectedStreet == null || shop.street.toLowerCase().includes(this.selectedStreet.toLowerCase());
    }).filter(shop => {
      return !this.selectedFavourite || shop.favourite;
    });
  }

  productList(shopId) {
    this.router.navigate(['/'+shopId+'/products']);
  }

  cart(shopId) {
    this.router.navigate(['/cart/'+shopId]);
  }

  changeFavourite(shop){
    const username = this.authenticationService.currentUserValue;
    this.connectionService.changeFavourite(shop.id, shop.favourite, username);
    shop.favourite = !shop.favourite;
  }
}
