import { HttpInterceptorFn, HttpErrorResponse } from '@angular/common/http';
import { inject } from '@angular/core';
import { catchError, throwError } from 'rxjs';
import { AuthService } from '../services/auth.service';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  // TODO: Implement JWT attachment and 401 handling:
  // 1. Inject AuthService and call getToken() to retrieve the stored JWT.
  // 2. If a token exists, clone the request and set the Authorization header:
  //      `Authorization: Bearer <token>`
  // 3. Forward the (possibly cloned) request with next().
  // 4. Use catchError to intercept HttpErrorResponse with status 401 —
  //    call auth.logout() to clear the session and redirect to /login,
  //    then re-throw the error.
  const auth = inject(AuthService);

  // Placeholder: pass the request through unmodified until implemented.
  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      if (error.status === 401) {
        // TODO: call auth.logout() here once logout() is implemented
      }
      return throwError(() => error);
    })
  );
};
