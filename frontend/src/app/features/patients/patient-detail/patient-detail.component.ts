import { Component, inject } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { DatePipe } from '@angular/common';
import { Patient } from '../../../core/models/patient.model';
import { Appointment } from '../../../core/models/appointment.model';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-patient-detail',
  standalone: true,
  imports: [RouterLink, DatePipe],
  templateUrl: './patient-detail.component.html',
  styleUrls: ['./patient-detail.component.scss']
})
export class PatientDetailComponent {
  private route  = inject(ActivatedRoute);
  protected auth = inject(AuthService);

  // Data provided by resolvers — no loading logic in the component
  protected patient:      Patient     = this.route.snapshot.data['patient'];
  protected appointments: Appointment[] = this.route.snapshot.data['appointments'] ?? [];
}
