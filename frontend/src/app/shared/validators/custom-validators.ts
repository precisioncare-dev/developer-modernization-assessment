import { AbstractControl, ValidationErrors, ValidatorFn } from '@angular/forms';

/** Ensures the date string is a valid, non-future date. */
export function pastDateValidator(): ValidatorFn {
  return (control: AbstractControl): ValidationErrors | null => {
    if (!control.value) return null;
    const date = new Date(control.value);
    if (isNaN(date.getTime())) return { invalidDate: true };
    if (date > new Date()) return { futureDate: true };
    return null;
  };
}

/** Ensures the date string is a valid, future date. */
export function futureDateValidator(): ValidatorFn {
  return (control: AbstractControl): ValidationErrors | null => {
    if (!control.value) return null;
    const date = new Date(control.value);
    if (isNaN(date.getTime())) return { invalidDate: true };
    if (date < new Date()) return { pastDate: true };
    return null;
  };
}

/** Validates a US phone number pattern. */
export function phoneValidator(): ValidatorFn {
  return (control: AbstractControl): ValidationErrors | null => {
    if (!control.value) return null;
    const pattern = /^[+]?[\d\s\-().]{7,20}$/;
    return pattern.test(control.value) ? null : { invalidPhone: true };
  };
}
