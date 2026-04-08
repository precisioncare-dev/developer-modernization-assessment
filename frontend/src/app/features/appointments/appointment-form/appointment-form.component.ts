import { Component } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-appointment-form',
  standalone: true,
  imports: [ReactiveFormsModule, RouterLink],
  templateUrl: './appointment-form.component.html',
  styleUrls: ['./appointment-form.component.scss']
})
export class AppointmentFormComponent {
  // TODO: Inject FormBuilder, AppointmentService, PatientService, ActivatedRoute, Router.

  // TODO: Define a reactive form covering all appointment fields:
  //   patientId, appointmentDate, duration, reason, status, providerName, notes.
  //   Apply appropriate Validators.

  // TODO: In ngOnInit:
  //   - Load the patient list for the dropdown via patientService.getAll().
  //   - Pre-select a patient if a `patientId` query param is present.

  // TODO: Implement onSubmit():
  //   1. Guard against invalid state.
  //   2. Call appointmentService.create(form.getRawValue()).
  //   3. Navigate to /appointments on success.
  //   4. Show an error message on failure.
}
