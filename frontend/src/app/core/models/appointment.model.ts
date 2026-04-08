export type AppointmentStatus = 'Scheduled' | 'Completed' | 'Cancelled' | 'NoShow';

export interface Appointment {
  appointmentId: number;
  patientId: number;
  patientFullName: string;
  appointmentDate: string; // ISO datetime string
  duration: number;
  reason: string;
  status: AppointmentStatus;
  providerName: string;
  notes?: string;
  createdAt: string;
}

export interface CreateAppointmentRequest {
  patientId: number;
  appointmentDate: string;
  duration: number;
  reason: string;
  status: AppointmentStatus;
  providerName: string;
  notes?: string;
}

export type UpdateAppointmentRequest = CreateAppointmentRequest;
