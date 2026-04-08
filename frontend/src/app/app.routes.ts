import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth.guard';
import { roleGuard } from './core/guards/role.guard';
import { patientListResolver } from './core/resolvers/patient-list.resolver';
import { patientResolver } from './core/resolvers/patient.resolver';
import { patientAppointmentsResolver } from './core/resolvers/patient-appointments.resolver';
import { appointmentListResolver } from './core/resolvers/appointment-list.resolver';
import { LayoutComponent } from './shared/components/layout/layout.component';

export const routes: Routes = [
  // ── Public ─────────────────────────────────────────────────────────────────
  {
    path: 'login',
    loadComponent: () =>
      import('./features/auth/login/login.component').then(m => m.LoginComponent)
  },

  // ── Protected (behind authGuard + shared layout) ────────────────────────────
  {
    path: '',
    component: LayoutComponent,
    canActivate: [authGuard],
    children: [
      { path: '', redirectTo: 'patients', pathMatch: 'full' },

      // Patients
      {
        path: 'patients',
        children: [
          {
            path: '',
            loadComponent: () =>
              import('./features/patients/patient-list/patient-list.component')
                .then(m => m.PatientListComponent),
            resolve: { patients: patientListResolver }
          },
          {
            path: 'new',
            canActivate: [roleGuard('Admin', 'Staff')],
            loadComponent: () =>
              import('./features/patients/patient-form/patient-form.component')
                .then(m => m.PatientFormComponent)
          },
          {
            path: ':id',
            loadComponent: () =>
              import('./features/patients/patient-detail/patient-detail.component')
                .then(m => m.PatientDetailComponent),
            resolve: {
              patient:      patientResolver,
              appointments: patientAppointmentsResolver
            }
          },
          {
            path: ':id/edit',
            canActivate: [roleGuard('Admin', 'Staff')],
            loadComponent: () =>
              import('./features/patients/patient-form/patient-form.component')
                .then(m => m.PatientFormComponent),
            resolve: { patient: patientResolver }
          }
        ]
      },

      // Appointments
      {
        path: 'appointments',
        children: [
          {
            path: '',
            loadComponent: () =>
              import('./features/appointments/appointment-list/appointment-list.component')
                .then(m => m.AppointmentListComponent),
            resolve: { appointments: appointmentListResolver }
          },
          {
            path: 'new',
            canActivate: [roleGuard('Admin', 'Staff')],
            loadComponent: () =>
              import('./features/appointments/appointment-form/appointment-form.component')
                .then(m => m.AppointmentFormComponent)
          }
        ]
      }
    ]
  },

  // Fallback
  { path: '**', redirectTo: 'patients' }
];
