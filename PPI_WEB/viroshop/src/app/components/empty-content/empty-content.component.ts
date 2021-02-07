import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-empty-content',
  templateUrl: './empty-content.component.html',
  styleUrls: ['./empty-content.component.scss']
})
export class EmptyContentComponent implements OnInit {

  @Input() message: String

  constructor() { }

  ngOnInit(): void {
  }

}
