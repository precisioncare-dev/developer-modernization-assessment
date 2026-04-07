import { inject } from '@angular/core';
import { ResolveFn, Router } from '@angular/router';
import { catchError, EMPTY } from 'rxjs';
import { Appointment } from '../models/appointment.model';
import { AppointmentService } from '../services/appointment.service';

/**
 * Resolves the appointment list before activating the appointment-list route.
 * Supports optional `status` and `date` query params.
 */
export const appointmentListResolver: ResolveFn<Appointment[]> = (route) => {
  const appointmentService = inject(AppointmentService);
  const router             = inject(Router);
  const status             = route.queryParamMap.get('status') ?? undefined;
  const date               = route.queryParamMap.get('date')   ?? undefined;

  return appointmentService.getAll(status, date).pipe(
    catchError(() => {
      router.navigate(['/error']);
      return EMPTY;
    })
  );
};
