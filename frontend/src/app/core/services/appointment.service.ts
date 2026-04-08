import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Appointment, CreateAppointmentRequest, UpdateAppointmentRequest } from '../models/appointment.model';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class AppointmentService {
  private readonly base = `${environment.apiUrl}/api/appointments`;

  constructor(private http: HttpClient) {}

  getAll(status?: string, date?: string): Observable<Appointment[]> {
    // TODO: GET ${this.base} with optional `status` and `date` query params.
    throw new Error('Not implemented: AppointmentService.getAll');
  }

  getById(id: number): Observable<Appointment> {
    // TODO: GET ${this.base}/${id}.
    throw new Error('Not implemented: AppointmentService.getById');
  }

  getByPatient(patientId: number): Observable<Appointment[]> {
    // TODO: GET `${environment.apiUrl}/api/patients/${patientId}/appointments`.
    throw new Error('Not implemented: AppointmentService.getByPatient');
  }

  create(request: CreateAppointmentRequest): Observable<Appointment> {
    // TODO: POST to ${this.base} with the request body.
    throw new Error('Not implemented: AppointmentService.create');
  }

  update(id: number, request: UpdateAppointmentRequest): Observable<Appointment> {
    // TODO: PUT to ${this.base}/${id} with the request body.
    throw new Error('Not implemented: AppointmentService.update');
  }
}
