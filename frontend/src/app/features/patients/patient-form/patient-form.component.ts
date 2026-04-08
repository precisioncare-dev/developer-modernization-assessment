import { Component } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-patient-form',
  standalone: true,
  imports: [ReactiveFormsModule, RouterLink],
  templateUrl: './patient-form.component.html',
  styleUrls: ['./patient-form.component.scss']
})
export class PatientFormComponent {
  // TODO: Inject FormBuilder, PatientService, ActivatedRoute, Router.

  // When editing, the patient is pre-loaded by patientResolver:
  //   this.route.snapshot.data['patient']  → Patient | undefined
  // If this data is present the form is in "edit" mode; otherwise "create".

  // TODO: Define a reactive form covering all patient fields:
  //   firstName, lastName, dateOfBirth, gender, email, phone,
  //   address, city, state, zipCode, insuranceId, notes.
  //   Apply appropriate Validators on each field.

  // TODO: In ngOnInit (or inline), patch the form if existingPatient is set.

  // TODO: Implement onSubmit():
  //   1. Guard against invalid state.
  //   2. Call patientService.create() or patientService.update() as appropriate.
  //   3. Navigate to the patient detail page on success.
  //   4. Show an error message on failure.
}
