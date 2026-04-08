import { inject } from '@angular/core';
import { ResolveFn, Router } from '@angular/router';
import { EMPTY } from 'rxjs';
import { Appointment } from '../models/appointment.model';
import { AppointmentService } from '../services/appointment.service';

/**
 * Resolves the appointment list before activating the appointment-list route.
 * Supports optional `status` and `date` query params.
 *
 * TODO: Implement this resolver:
 * 1. inject AppointmentService and Router.
 * 2. Read optional `status` and `date` query params from `route.queryParamMap`.
 * 3. Call appointmentService.getAll(status, date) and return the observable.
 * 4. Use catchError to navigate to an error route and return EMPTY on failure.
 */
export const appointmentListResolver: ResolveFn<Appointment[]> = (_route) => {
  // placeholder — replace with real implementation
  return EMPTY;
};
