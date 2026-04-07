import { Component, inject, OnInit } from '@angular/core';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { AppointmentService } from '../../../core/services/appointment.service';
import { PatientService } from '../../../core/services/patient.service';
import { Patient } from '../../../core/models/patient.model';
import { futureDateValidator } from '../../../shared/validators/custom-validators';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-appointment-form',
  standalone: true,
  imports: [ReactiveFormsModule, RouterLink],
  templateUrl: './appointment-form.component.html',
  styleUrls: ['./appointment-form.component.scss']
})
export class AppointmentFormComponent implements OnInit {
  private fb                  = inject(FormBuilder);
  private appointmentService  = inject(AppointmentService);
  private patientService      = inject(PatientService);
  private route               = inject(ActivatedRoute);
  private router              = inject(Router);

  protected patients: Patient[] = [];
  protected isLoading    = false;
  protected errorMessage = '';

  readonly statuses = ['Scheduled', 'Completed', 'Cancelled', 'NoShow'];

  protected form = this.fb.nonNullable.group({
    patientId:       [0, [Validators.required, Validators.min(1)]],
    appointmentDate: ['', [Validators.required]],
    duration:        [30, [Validators.required, Validators.min(5), Validators.max(480)]],
    reason:          ['', [Validators.required, Validators.maxLength(500)]],
    status:          ['Scheduled', Validators.required],
    providerName:    ['', [Validators.required, Validators.maxLength(100)]],
    notes:           ['']
  });

  protected get f() { return this.form.controls; }

  ngOnInit(): void {
    // Pre-select patient if navigated from patient-detail page
    const preselectedPatientId = this.route.snapshot.queryParamMap.get('patientId');
    if (preselectedPatientId) {
      this.form.patchValue({ patientId: Number(preselectedPatientId) });
    }

    // Load patient dropdown list
    this.patientService.getAll().subscribe(patients => (this.patients = patients));
  }

  protected onSubmit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    this.isLoading    = true;
    this.errorMessage = '';

    this.appointmentService.create(this.form.getRawValue() as any).subscribe({
      next: () => this.router.navigate(['/appointments']),
      error: () => {
        this.errorMessage = 'Failed to save appointment. Please try again.';
        this.isLoading    = false;
      }
    });
  }
}
