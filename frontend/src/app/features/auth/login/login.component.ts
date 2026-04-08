import { Component } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  // TODO: Inject FormBuilder, AuthService, Router, and ActivatedRoute.

  // TODO: Define a reactive form with `username` and `password` controls.
  //       Apply appropriate Validators (required, minLength, maxLength).

  // TODO: Implement onSubmit():
  //   1. Guard against invalid form state (mark all controls as touched).
  //   2. Call authService.login(credentials).subscribe(...)
  //   3. On success navigate to `returnUrl` query param or '/patients'.
  //   4. On error display a user-friendly error message.
}
