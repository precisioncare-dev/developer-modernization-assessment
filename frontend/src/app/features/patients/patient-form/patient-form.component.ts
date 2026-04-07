import { Component, inject, OnInit } from '@angular/core';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { Patient } from '../../../core/models/patient.model';
import { PatientService } from '../../../core/services/patient.service';
import { pastDateValidator } from '../../../shared/validators/custom-validators';

@Component({
  selector: 'app-patient-form',
  standalone: true,
  imports: [ReactiveFormsModule, RouterLink],
  templateUrl: './patient-form.component.html',
  styleUrls: ['./patient-form.component.scss']
})
export class PatientFormComponent implements OnInit {
  private fb             = inject(FormBuilder);
  private patientService = inject(PatientService);
  private route          = inject(ActivatedRoute);
  private router         = inject(Router);

  // Resolved by `patientResolver` when editing; null for new patient
  protected existingPatient: Patient | null = this.route.snapshot.data['patient'] ?? null;

  protected isEdit    = this.existingPatient !== null;
  protected isLoading = false;
  protected errorMessage = '';

  protected form = this.fb.nonNullable.group({
    firstName:   ['', [Validators.required, Validators.maxLength(50)]],
    lastName:    ['', [Validators.required, Validators.maxLength(50)]],
    dateOfBirth: ['', [Validators.required, pastDateValidator()]],
    gender:      ['', Validators.required],
    email:       ['', [Validators.email, Validators.maxLength(150)]],
    phone:       ['', Validators.maxLength(20)],
    address:     ['', Validators.maxLength(250)],
    city:        ['', Validators.maxLength(100)],
    state:       ['', Validators.maxLength(50)],
    zipCode:     ['', Validators.maxLength(10)],
    insuranceId: ['', Validators.maxLength(50)],
    notes:       ['']
  });

  // Shortcuts for template
  protected get f() { return this.form.controls; }

  ngOnInit(): void {
    if (this.existingPatient) {
      this.form.patchValue({
        ...this.existingPatient,
        dateOfBirth: this.existingPatient.dateOfBirth
      });
    }
  }

  protected onSubmit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    this.isLoading     = true;
    this.errorMessage  = '';
    const payload = this.form.getRawValue();

    const request$ = this.isEdit
      ? this.patientService.update(this.existingPatient!.patientId, payload)
      : this.patientService.create(payload);

    request$.subscribe({
      next: patient => this.router.navigate(['/patients', patient.patientId]),
      error: () => {
        this.errorMessage = 'Failed to save patient. Please try again.';
        this.isLoading    = false;
      }
    });
  }
}
