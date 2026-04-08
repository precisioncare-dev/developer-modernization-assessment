import { Injectable, signal, computed } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { LoginRequest, LoginResponse, User } from '../models/user.model';
import { environment } from '../../../environments/environment';

const TOKEN_KEY = 'pc_token';
const USER_KEY  = 'pc_user';

@Injectable({ providedIn: 'root' })
export class AuthService {
  // Signals — keep these declarations so guards and the navbar compile.
  // TODO: Initialize _currentUser by reading from localStorage on startup
  //       (remember to discard tokens that have already expired).
  private readonly _currentUser = signal<User | null>(null);

  readonly currentUser = this._currentUser.asReadonly();
  readonly isLoggedIn  = computed(() => this._currentUser() !== null);
  readonly userRole    = computed(() => this._currentUser()?.role ?? null);

  constructor(private http: HttpClient, private router: Router) {}

  login(credentials: LoginRequest): Observable<LoginResponse> {
    // TODO: POST credentials to `${environment.apiUrl}/api/auth/login`.
    // On success, persist the token (TOKEN_KEY) and user object (USER_KEY)
    // in localStorage, then update _currentUser via set().
    // Use the `tap` operator so the observable chain remains intact for callers.
    throw new Error('Not implemented: AuthService.login');
  }

  logout(): void {
    // TODO: Remove TOKEN_KEY and USER_KEY from localStorage,
    // reset _currentUser to null, and navigate to /login.
    throw new Error('Not implemented: AuthService.logout');
  }

  getToken(): string | null {
    // TODO: Return the stored JWT from localStorage, or null.
    return null; // placeholder — replace with localStorage.getItem(TOKEN_KEY)
  }

  hasRole(...roles: string[]): boolean {
    // TODO: Return true if the current user's role is included in `roles`.
    return false; // placeholder — replace with real role check
  }
}
