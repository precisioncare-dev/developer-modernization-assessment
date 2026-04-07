import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Appointment, CreateAppointmentRequest, UpdateAppointmentRequest } from '../models/appointment.model';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class AppointmentService {
  private readonly base = `${environment.apiUrl}/api/appointments`;

  constructor(private http: HttpClient) {}

  getAll(status?: string, date?: string): Observable<Appointment[]> {
    let params = new HttpParams();
    if (status) params = params.set('status', status);
    if (date)   params = params.set('date', date);
    return this.http.get<Appointment[]>(this.base, { params });
  }

  getById(id: number): Observable<Appointment> {
    return this.http.get<Appointment>(`${this.base}/${id}`);
  }

  getByPatient(patientId: number): Observable<Appointment[]> {
    return this.http.get<Appointment[]>(
      `${environment.apiUrl}/api/patients/${patientId}/appointments`
    );
  }

  create(request: CreateAppointmentRequest): Observable<Appointment> {
    return this.http.post<Appointment>(this.base, request);
  }

  update(id: number, request: UpdateAppointmentRequest): Observable<Appointment> {
    return this.http.put<Appointment>(`${this.base}/${id}`, request);
  }
}
