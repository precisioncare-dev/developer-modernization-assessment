import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ReactiveFormsModule } from '@angular/forms';
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-patient-list',
  standalone: true,
  imports: [RouterLink, ReactiveFormsModule, DatePipe],
  templateUrl: './patient-list.component.html',
  styleUrls: ['./patient-list.component.scss']
})
export class PatientListComponent {
  // TODO: Inject ActivatedRoute, Router, PatientService, AuthService, FormBuilder.

  // Data is pre-loaded by patientListResolver — read from the route snapshot:
  //   this.route.snapshot.data['patients']
  // The component should NOT make its own HTTP calls for initial data.

  // TODO: Define a search reactive form with a single `search` control.

  // TODO: Implement onSearch():
  //   Navigate on the same route with an updated `search` query param so the
  //   resolver automatically reloads the data.

  // TODO: Implement onDelete(id: number):
  //   Confirm with the user, call patientService.delete(id), then remove the
  //   deleted patient from the local list on success.
}
