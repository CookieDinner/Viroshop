import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OrderProductsDialogComponent } from './order-products-dialog.component';

describe('OrderProductsDialogComponent', () => {
  let component: OrderProductsDialogComponent;
  let fixture: ComponentFixture<OrderProductsDialogComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ OrderProductsDialogComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(OrderProductsDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
