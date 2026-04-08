import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

/**
 * Usage in routes:
 *   canActivate: [roleGuard('Admin', 'Staff')]
 */
export function roleGuard(...allowedRoles: string[]): CanActivateFn {
  return (_route, _state) => {
    // TODO: Inject AuthService and Router.
    // 1. If the user is not logged in, redirect to /login.
    // 2. If the user IS logged in but does not have one of the allowedRoles,
    //    redirect to /patients (or an appropriate "access denied" route).
    // 3. Otherwise allow navigation.
    const auth   = inject(AuthService);
    const router = inject(Router);

    if (!auth.isLoggedIn()) {
      return router.createUrlTree(['/login']);
    }

    // TODO: Implement role check — replace this placeholder with a call to
    // auth.hasRole(...allowedRoles) once AuthService.hasRole is implemented.
    return router.createUrlTree(['/patients']);
  };
}
