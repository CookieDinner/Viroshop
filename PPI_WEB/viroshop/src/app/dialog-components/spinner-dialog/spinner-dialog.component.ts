import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-spinner-dialog',
  templateUrl: './spinner-dialog.component.html',
  styleUrls: ['./spinner-dialog.component.scss']
})
export class SpinnerDialogComponent implements OnInit {

  mode = "indeterminate";
  color = "primary";
  
  constructor() { }

  ngOnInit(): void {
  }

}
