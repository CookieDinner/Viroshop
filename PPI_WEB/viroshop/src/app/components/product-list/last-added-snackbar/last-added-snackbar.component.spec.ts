import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LastAddedSnackbarComponent } from './last-added-snackbar.component';

describe('LastAddedSnackbarComponent', () => {
  let component: LastAddedSnackbarComponent;
  let fixture: ComponentFixture<LastAddedSnackbarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LastAddedSnackbarComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LastAddedSnackbarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
