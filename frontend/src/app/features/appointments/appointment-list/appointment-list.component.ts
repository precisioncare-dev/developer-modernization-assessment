import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ReactiveFormsModule } from '@angular/forms';
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-appointment-list',
  standalone: true,
  imports: [RouterLink, ReactiveFormsModule, DatePipe],
  templateUrl: './appointment-list.component.html',
  styleUrls: ['./appointment-list.component.scss']
})
export class AppointmentListComponent {
  // TODO: Inject ActivatedRoute, Router, FormBuilder.

  // Data is pre-loaded by appointmentListResolver — read from the route snapshot:
  //   this.route.snapshot.data['appointments']
  // The component should NOT make its own HTTP calls for initial data.

  // TODO: Define a filter reactive form with `status` and `date` controls.

  // TODO: Implement onFilter():
  //   Navigate with updated `status` and `date` query params so the resolver
  //   reloads the data automatically.

  // TODO: Implement clearFilters():
  //   Reset the form and navigate to /appointments with no query params.
}
