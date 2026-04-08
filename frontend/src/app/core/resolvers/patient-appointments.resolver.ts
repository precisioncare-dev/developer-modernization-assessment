import { inject } from '@angular/core';
import { ResolveFn, Router } from '@angular/router';
import { EMPTY } from 'rxjs';
import { Appointment } from '../models/appointment.model';
import { AppointmentService } from '../services/appointment.service';

/**
 * Resolves all appointments for a patient identified by :id in the
 * patient-detail route so the component receives data immediately.
 *
 * TODO: Implement this resolver:
 * 1. inject AppointmentService and Router.
 * 2. Parse the patient id: `Number(route.paramMap.get('id'))`.
 * 3. Call appointmentService.getByPatient(patientId) and return the observable.
 * 4. Use catchError to navigate to /patients and return EMPTY on failure.
 */
export const patientAppointmentsResolver: ResolveFn<Appointment[]> = (_route) => {
  // placeholder — replace with real implementation
  return EMPTY;
};
