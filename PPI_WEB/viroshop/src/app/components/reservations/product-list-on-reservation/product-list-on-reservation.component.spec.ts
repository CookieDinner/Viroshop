import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProductListOnReservationComponent } from './product-list-on-reservation.component';

describe('ProductListOnReservationComponent', () => {
  let component: ProductListOnReservationComponent;
  let fixture: ComponentFixture<ProductListOnReservationComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ProductListOnReservationComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ProductListOnReservationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
