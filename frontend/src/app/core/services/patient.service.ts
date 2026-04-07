import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Patient, CreatePatientRequest, UpdatePatientRequest } from '../models/patient.model';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class PatientService {
  private readonly base = `${environment.apiUrl}/api/patients`;

  constructor(private http: HttpClient) {}

  getAll(search?: string): Observable<Patient[]> {
    let params = new HttpParams();
    if (search) params = params.set('search', search);
    return this.http.get<Patient[]>(this.base, { params });
  }

  getById(id: number): Observable<Patient> {
    return this.http.get<Patient>(`${this.base}/${id}`);
  }

  create(request: CreatePatientRequest): Observable<Patient> {
    return this.http.post<Patient>(this.base, request);
  }

  update(id: number, request: UpdatePatientRequest): Observable<Patient> {
    return this.http.put<Patient>(`${this.base}/${id}`, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.base}/${id}`);
  }
}
