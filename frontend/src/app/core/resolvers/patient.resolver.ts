import { inject } from '@angular/core';
import { ResolveFn, Router } from '@angular/router';
import { catchError, EMPTY } from 'rxjs';
import { Patient } from '../models/patient.model';
import { PatientService } from '../services/patient.service';

/**
 * Resolves a single patient by :id before activating the patient-detail
 * and patient-form (edit) routes. Redirects to /patients on not-found.
 */
export const patientResolver: ResolveFn<Patient> = (route) => {
  const patientService = inject(PatientService);
  const router         = inject(Router);
  const id             = Number(route.paramMap.get('id'));

  return patientService.getById(id).pipe(
    catchError(() => {
      router.navigate(['/patients']);
      return EMPTY;
    })
  );
};
