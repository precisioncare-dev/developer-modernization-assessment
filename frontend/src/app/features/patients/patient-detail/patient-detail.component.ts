import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-patient-detail',
  standalone: true,
  imports: [RouterLink, DatePipe],
  templateUrl: './patient-detail.component.html',
  styleUrls: ['./patient-detail.component.scss']
})
export class PatientDetailComponent {
  // TODO: Inject ActivatedRoute and AuthService.

  // Both datasets are pre-loaded by resolvers — read from the route snapshot:
  //   this.route.snapshot.data['patient']       → Patient
  //   this.route.snapshot.data['appointments']  → Appointment[]
  // The component should NOT make its own HTTP calls.
}
