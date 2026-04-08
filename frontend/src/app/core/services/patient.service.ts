import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Patient, CreatePatientRequest, UpdatePatientRequest } from '../models/patient.model';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class PatientService {
  private readonly base = `${environment.apiUrl}/api/patients`;

  constructor(private http: HttpClient) {}

  getAll(search?: string): Observable<Patient[]> {
    // TODO: GET ${this.base} with an optional `search` query param.
    throw new Error('Not implemented: PatientService.getAll');
  }

  getById(id: number): Observable<Patient> {
    // TODO: GET ${this.base}/${id}.
    throw new Error('Not implemented: PatientService.getById');
  }

  create(request: CreatePatientRequest): Observable<Patient> {
    // TODO: POST to ${this.base} with the request body.
    throw new Error('Not implemented: PatientService.create');
  }

  update(id: number, request: UpdatePatientRequest): Observable<Patient> {
    // TODO: PUT to ${this.base}/${id} with the request body.
    throw new Error('Not implemented: PatientService.update');
  }

  delete(id: number): Observable<void> {
    // TODO: DELETE ${this.base}/${id}.
    throw new Error('Not implemented: PatientService.delete');
  }
}
