export interface Patient {
  patientId: number;
  firstName: string;
  lastName: string;
  fullName: string;
  dateOfBirth: string; // ISO date string (yyyy-MM-dd)
  gender: string;
  email?: string;
  phone?: string;
  address?: string;
  city?: string;
  state?: string;
  zipCode?: string;
  insuranceId?: string;
  notes?: string;
  createdAt: string;
  updatedAt?: string;
}

export interface CreatePatientRequest {
  firstName: string;
  lastName: string;
  dateOfBirth: string;
  gender: string;
  email?: string;
  phone?: string;
  address?: string;
  city?: string;
  state?: string;
  zipCode?: string;
  insuranceId?: string;
  notes?: string;
}

export type UpdatePatientRequest = CreatePatientRequest;
