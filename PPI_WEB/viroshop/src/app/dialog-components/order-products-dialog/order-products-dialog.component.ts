import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-order-products-dialog',
  templateUrl: './order-products-dialog.component.html',
  styleUrls: ['./order-products-dialog.component.scss']
})
export class OrderProductsDialogComponent implements OnInit {

  step = 0;
  
  constructor(
    private dialogRef: MatDialogRef<OrderProductsDialogComponent>
  ) {}

  ngOnInit(): void {
  }

  nextStep(): void {
    this.step += 1;
  }

  succeed() {
    this.dialogRef.close('success');
  }
  
  failed() {
    this.dialogRef.close('failed');
  }
}
