import { Component, inject } from '@angular/core';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { DatePipe } from '@angular/common';
import { Patient } from '../../../core/models/patient.model';
import { PatientService } from '../../../core/services/patient.service';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-patient-list',
  standalone: true,
  imports: [RouterLink, ReactiveFormsModule, DatePipe],
  templateUrl: './patient-list.component.html',
  styleUrls: ['./patient-list.component.scss']
})
export class PatientListComponent {
  private route          = inject(ActivatedRoute);
  private router         = inject(Router);
  private patientService = inject(PatientService);
  protected auth         = inject(AuthService);
  private fb             = inject(FormBuilder);

  // Data provided by the resolver — no loading logic in the component
  protected patients: Patient[] = this.route.snapshot.data['patients'] ?? [];

  protected searchForm = this.fb.nonNullable.group({
    search: [this.route.snapshot.queryParamMap.get('search') ?? '']
  });

  protected errorMessage = '';

  protected onSearch(): void {
    const search = this.searchForm.getRawValue().search.trim() || undefined;
    // Navigate with query param so the resolver reloads data
    this.router.navigate([], {
      relativeTo: this.route,
      queryParams: { search: search ?? null },
      queryParamsHandling: 'merge'
    });
  }

  protected onDelete(id: number): void {
    if (!confirm('Are you sure you want to delete this patient?')) return;
    this.patientService.delete(id).subscribe({
      next: () => {
        this.patients = this.patients.filter(p => p.patientId !== id);
      },
      error: () => {
        this.errorMessage = 'Failed to delete patient. Please try again.';
      }
    });
  }
}
