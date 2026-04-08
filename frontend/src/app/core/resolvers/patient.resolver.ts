import { inject } from '@angular/core';
import { ResolveFn, Router } from '@angular/router';
import { EMPTY } from 'rxjs';
import { Patient } from '../models/patient.model';
import { PatientService } from '../services/patient.service';

/**
 * Resolves a single patient by :id before activating the patient-detail
 * and patient-form (edit) routes. Redirects to /patients on not-found.
 *
 * TODO: Implement this resolver:
 * 1. inject PatientService and Router.
 * 2. Parse the `id` route param: `Number(route.paramMap.get('id'))`.
 * 3. Call patientService.getById(id) and return the observable.
 * 4. Use catchError to navigate to /patients and return EMPTY on failure.
 */
export const patientResolver: ResolveFn<Patient> = (_route) => {
  // placeholder — replace with real implementation
  return EMPTY;
};
