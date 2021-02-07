import { Component, OnInit, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MatPaginator } from '@angular/material/paginator';
import { MatTableDataSource } from '@angular/material/table';
import { ActivatedRoute, Router } from '@angular/router';
import { first } from 'rxjs/operators';
import { PictureDialogComponent } from 'src/app/dialog-components/picture-dialog/picture-dialog.component';
import { CartService } from 'src/app/services/cart.service';
import { ConnectionService } from 'src/app/services/connection.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { LastAddedSnackbarComponent } from './last-added-snackbar/last-added-snackbar.component';

@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.scss']
})
export class ProductListComponent implements OnInit {

  loading = false;

  filteredProducts = new MatTableDataSource<any>();
  productList = [];

  shopId;

  types = new Set();
  filterType = null;
  filterName = '';

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private connectionService: ConnectionService,
    private cartService: CartService,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) {
   }

  ngOnInit(): void {
    this.loading = true;
    this.shopId = this.route.snapshot.paramMap.get('shop');
    this.connectionService.getProducts(this.shopId).pipe(first()).subscribe(
      result => {
        result.map(element => {
          element.count = 1;
        });
        this.types = new Set();
        result.forEach(element => {
          this.types.add(element.category)
        });
        this.productList = result;
        this.filterProducts();
        this.loading = false;
      },
      error => {
        this.loading = false;
      }
    )
  }

  displayedColumns: string[] = ['photo', 'name', 'type', 'actions', 'onePrice', 'price'];

  @ViewChild(MatPaginator) paginator: MatPaginator;

  ngAfterViewInit() {
    this.filteredProducts.paginator = this.paginator;
  }

  increase(id) {
    this.productList.map(element => {
      if (element.id == id) {
        element.count += 1;
      }
    });
  }

  decrease(id) {
    this.productList.map(element => {
      if (element.id == id && element.count > 1) {
        element.count -= 1;
      }
    });
  }

  addToCart(product) {
    this.cartService.addProduct(this.shopId, product);
    this.openSnackBar(JSON.parse(JSON.stringify(product)));
    product.count = 1;
  }

  preventCountUnder0(element){
    if (element.count != "" && element.count != null && element.count < 1) element.count = 1;
  }

  filterProducts() {
    this.filteredProducts.data = this.productList.filter(product => {
      return this.filterType == null || product.category == this.filterType;
    }).filter(product => {
      return this.filterName == null || product.name.toLowerCase().includes(this.filterName.toLowerCase());
    });
  }

  openPictureDialog(source) {
    this.dialog.open(PictureDialogComponent, {
      data: source
    });
  }

  lastAddedProducts = [];
  openSnackBar(product) {
    if (this.lastAddedProducts.length < 5) {
      this.lastAddedProducts.push(product);
    } else {
      this.lastAddedProducts = this.lastAddedProducts.slice(1, 5);
      this.lastAddedProducts.push(product);
    }

    this.snackBar.openFromComponent(LastAddedSnackbarComponent, {
      data: this.lastAddedProducts,
      duration: 2000,
      horizontalPosition: 'end',
      verticalPosition: 'top',
    });
  }

  goToCart() {
    this.router.navigate(['/cart/'+this.shopId]);
  }

}
