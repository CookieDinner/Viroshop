import { Component, Inject } from '@angular/core';
import { MAT_SNACK_BAR_DATA } from '@angular/material/snack-bar';

@Component({
  selector: 'app-last-added-snackbar',
  templateUrl: './last-added-snackbar.component.html',
  styleUrls: ['./last-added-snackbar.component.scss']
})
export class LastAddedSnackbarComponent {
  constructor(@Inject(MAT_SNACK_BAR_DATA) public data: any) { }  
}
