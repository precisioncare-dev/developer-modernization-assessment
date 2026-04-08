import { inject } from '@angular/core';
import { ResolveFn, Router } from '@angular/router';
import { EMPTY } from 'rxjs';
import { Patient } from '../models/patient.model';
import { PatientService } from '../services/patient.service';

/**
 * Resolves the full patient list before activating the patient-list route.
 * Supports an optional `search` query param forwarded from the route.
 *
 * TODO: Implement this resolver:
 * 1. inject PatientService and Router.
 * 2. Read an optional `search` query param from `route.queryParamMap`.
 * 3. Call patientService.getAll(search) and return the observable.
 * 4. Use catchError to navigate to an error route and return EMPTY on failure.
 */
export const patientListResolver: ResolveFn<Patient[]> = (_route) => {
  // placeholder — replace with real implementation
  return EMPTY;
};
