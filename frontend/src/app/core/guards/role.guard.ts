import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

/**
 * Usage in routes:
 *   canActivate: [roleGuard('Admin', 'Staff')]
 */
export function roleGuard(...allowedRoles: string[]): CanActivateFn {
  return (_route, _state) => {
    const auth   = inject(AuthService);
    const router = inject(Router);

    if (!auth.isLoggedIn()) {
      return router.createUrlTree(['/login']);
    }

    if (auth.hasRole(...allowedRoles)) return true;

    // User is authenticated but doesn't have the required role
    return router.createUrlTree(['/patients']);
  };
}
