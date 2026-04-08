import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const authGuard: CanActivateFn = (_route, state) => {
  // TODO: Inject AuthService and Router.
  // If the user is logged in, allow navigation (return true).
  // Otherwise redirect to /login, preserving the attempted URL as a
  // `returnUrl` query parameter so the user is sent back after login.
  const auth   = inject(AuthService);
  const router = inject(Router);

  if (auth.isLoggedIn()) return true;

  // TODO: Replace the redirect below with a UrlTree that includes
  // `queryParams: { returnUrl: state.url }` so the login page can redirect
  // back after a successful login.
  return router.createUrlTree(['/login']);
};
