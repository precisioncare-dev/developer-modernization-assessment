import { Component, inject } from '@angular/core';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { DatePipe } from '@angular/common';
import { Appointment } from '../../../core/models/appointment.model';

@Component({
  selector: 'app-appointment-list',
  standalone: true,
  imports: [RouterLink, ReactiveFormsModule, DatePipe],
  templateUrl: './appointment-list.component.html',
  styleUrls: ['./appointment-list.component.scss']
})
export class AppointmentListComponent {
  private route  = inject(ActivatedRoute);
  private router = inject(Router);
  private fb     = inject(FormBuilder);

  // Data provided by the resolver — no loading logic in the component
  protected appointments: Appointment[] = this.route.snapshot.data['appointments'] ?? [];

  protected filterForm = this.fb.nonNullable.group({
    status: [this.route.snapshot.queryParamMap.get('status') ?? ''],
    date:   [this.route.snapshot.queryParamMap.get('date')   ?? '']
  });

  readonly statuses = ['Scheduled', 'Completed', 'Cancelled', 'NoShow'];

  protected onFilter(): void {
    const { status, date } = this.filterForm.getRawValue();
    this.router.navigate([], {
      relativeTo: this.route,
      queryParams: {
        status: status || null,
        date:   date   || null
      },
      queryParamsHandling: 'merge'
    });
  }

  protected clearFilters(): void {
    this.filterForm.reset({ status: '', date: '' });
    this.router.navigate(['/appointments']);
  }
}
