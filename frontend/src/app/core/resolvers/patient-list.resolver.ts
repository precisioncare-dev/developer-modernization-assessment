import { inject } from '@angular/core';
import { ResolveFn, Router } from '@angular/router';
import { catchError, EMPTY } from 'rxjs';
import { Patient } from '../models/patient.model';
import { PatientService } from '../services/patient.service';

/**
 * Resolves the full patient list before activating the patient-list route.
 * Supports an optional `search` query param forwarded from the route.
 */
export const patientListResolver: ResolveFn<Patient[]> = (route) => {
  const patientService = inject(PatientService);
  const router         = inject(Router);
  const search         = route.queryParamMap.get('search') ?? undefined;

  return patientService.getAll(search).pipe(
    catchError(() => {
      router.navigate(['/error']);
      return EMPTY;
    })
  );
};
