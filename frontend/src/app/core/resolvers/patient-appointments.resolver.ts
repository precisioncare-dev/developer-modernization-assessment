import { inject } from '@angular/core';
import { ResolveFn, Router } from '@angular/router';
import { catchError, EMPTY } from 'rxjs';
import { Appointment } from '../models/appointment.model';
import { AppointmentService } from '../services/appointment.service';

/**
 * Resolves all appointments for a patient identified by :patientId in the
 * patient-detail route so the component receives data immediately.
 */
export const patientAppointmentsResolver: ResolveFn<Appointment[]> = (route) => {
  const appointmentService = inject(AppointmentService);
  const router             = inject(Router);
  const patientId          = Number(route.paramMap.get('id'));

  return appointmentService.getByPatient(patientId).pipe(
    catchError(() => {
      router.navigate(['/patients']);
      return EMPTY;
    })
  );
};
