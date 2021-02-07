import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { BehaviorSubject } from 'rxjs';
import { map } from 'rxjs/operators';
import * as moment from 'moment';

@Injectable({
  providedIn: 'root'
})
export class AuthenticationService {

  private loginUrl = "http://localhost:8080/api/user/login";
  private registerUrl = "http://localhost:8080/api/user/register";
  private forgotPasswordUrl = "http://localhost:8080/api/user/password/forgot";
  private changePasswordUrl = "http://localhost:8080/api/user/password/change";

  currentUserSubject: BehaviorSubject<any>;

  constructor(private httpClient: HttpClient) {
    const localItem = JSON.parse(localStorage.getItem('currentUser'));
    if (localItem && moment().isSameOrBefore(localItem.valid)) {
      this.currentUserSubject = new BehaviorSubject(localItem.login);
    } else {
      this.currentUserSubject = new BehaviorSubject(null);
    }
  }

  public get currentUserValue() {
      return this.currentUserSubject.value;
  }

  login(login, password) {
    return this.httpClient.post(
      this.loginUrl,
      {login: login, password: password},
      {responseType: 'text'})
      .pipe(map(_ => {
        const loginLocal = {
          login: login,
          valid: moment().add(2, 'h')
        }
        localStorage.setItem('currentUser', JSON.stringify(loginLocal));
        this.currentUserSubject.next(login);
        return login;
      }));
  }

  register(requestBody) {
    return this.httpClient.post(
      this.registerUrl,
      requestBody,
      {responseType: 'text'}
    );
  }

  forgorPassword(login) {
    return this.httpClient.post(
      this.forgotPasswordUrl,
      null,
      {
        responseType: 'text',
        params: new HttpParams().append("userLogin", login)
      }
    );
  }

  changePassword(requestBody) {
    return this.httpClient.post(
      this.changePasswordUrl,
      requestBody,
      { responseType: 'text' }
    );
  }

  logout() {
    localStorage.removeItem('currentUser');
    this.currentUserSubject.next(null);
  }
}