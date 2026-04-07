import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';
import { User } from '../../../core/models/user.model';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [RouterLink, RouterLinkActive],
  template: `
    <nav class="navbar">
      <span class="brand">PrecisionCare</span>
      <div class="nav-links">
        <a routerLink="/patients"     routerLinkActive="active">Patients</a>
        <a routerLink="/appointments" routerLinkActive="active">Appointments</a>
      </div>
      <div class="user-info">
        <span class="user-name">{{ currentUser?.fullName }}</span>
        <span class="user-role">{{ currentUser?.role }}</span>
        <button (click)="auth.logout()">Logout</button>
      </div>
    </nav>
  `,
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent {
  protected auth = inject(AuthService);

  get currentUser(): User | null {
    return this.auth.currentUser();
  }
}
