using FluentAssertions;
using Moq;
using PrecisionCare.Api.DTOs.Appointments;
using PrecisionCare.Api.Services;
using Xunit;

namespace PrecisionCare.Api.Tests.Services;

// =============================================================================
// AppointmentServiceTests
// =============================================================================
// Grading rubric contribution: Code Quality & Practices — Unit Testing (see README)
//
// These tests verify AppointmentService in isolation using an EF Core in-memory
// database.  You will need at least one Patient row in the context because
// Appointment has a required foreign key to Patient.
//
// Pattern to follow (same as PatientServiceTests)
// ------------------------------------------------
//   1. CreateContext() → UseInMemoryDatabase unique per test.
//   2. Seed a Patient (required FK) and one or more Appointments.
//   3. new AppointmentService(context) → system under test.
//   4. Assert return values AND database state for write operations.
//
// Required coverage (minimum — add more tests to earn full marks)
// ---------------------------------------------------------------
//   ✔  GetAllAsync — no filters       → returns all appointments ordered by date asc
//   ✔  GetAllAsync — status filter    → returns only matching appointments
//   ✔  GetAllAsync — date filter      → returns only matching appointments
//   ✔  GetAllAsync — combined filters → status AND date both applied
//   ✔  GetByIdAsync — existing id     → returns correct AppointmentDto (with patient name)
//   ✔  GetByIdAsync — missing id      → returns null
//   ✔  GetByPatientIdAsync            → returns only that patient's appointments, newest first
//   ✔  CreateAsync                    → saves record, DTO has assigned AppointmentId
//   ✔  UpdateAsync — existing id      → persists changes, returns updated DTO
//   ✔  UpdateAsync — missing id       → returns null
// =============================================================================

public class AppointmentServiceTests
{
    // TODO: Declare shared helpers here, e.g.:
    //
    //   private static AppDbContext CreateContext() => ...;
    //
    //   private static Patient SamplePatient() => new()
    //   {
    //       PatientId = 1, FirstName = "Alice", LastName = "Anderson",
    //       DateOfBirth = new DateOnly(1990, 1, 1), Gender = "Female"
    //   };
    //
    //   private static Appointment SampleAppointment(int patientId) => new()
    //   {
    //       PatientId = patientId,
    //       AppointmentDate = DateTime.UtcNow.AddDays(1),
    //       Duration = 30, Reason = "Annual checkup",
    //       Status = "Scheduled", ProviderName = "Dr. Smith"
    //   };

    // =========================================================================
    // GetAllAsync
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAllAsync_NoFilters_ReturnsAllOrderedByDateAscending()
    {
        // TODO: Seed two appointments with different dates.
        //       Call GetAllAsync(status: null, date: null).
        //       Assert both are returned and the earlier date comes first.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAllAsync_StatusFilter_ReturnsOnlyMatchingAppointments()
    {
        // TODO: Seed one "Scheduled" and one "Completed" appointment.
        //       Call GetAllAsync(status: "Scheduled").
        //       Assert only the Scheduled appointment is returned.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAllAsync_DateFilter_ReturnsOnlyAppointmentsOnThatDay()
    {
        // TODO: Seed appointments on two different days.
        //       Call GetAllAsync(date: targetDate).
        //       Assert only the appointments on targetDate are returned.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAllAsync_StatusAndDateFilters_BothApplied()
    {
        // TODO: Seed four appointments covering all combinations of
        //       two statuses × two dates.
        //       Call GetAllAsync with one status and one date.
        //       Assert only the single appointment that matches both is returned.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // GetByIdAsync
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetByIdAsync_ExistingId_ReturnsCorrectDtoWithPatientName()
    {
        // TODO: Seed a Patient and an Appointment linked to that patient.
        //       Call GetByIdAsync with the appointment's id.
        //       Assert the DTO is non-null and PatientFullName == "FirstName LastName".
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetByIdAsync_MissingId_ReturnsNull()
    {
        // TODO: Call GetByIdAsync with an id that does not exist.
        //       Assert the result is null.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // GetByPatientIdAsync
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetByPatientIdAsync_ReturnsOnlyThatPatientsAppointments()
    {
        // TODO: Seed two patients each with one appointment.
        //       Call GetByPatientIdAsync(patientOneId).
        //       Assert only patient one's appointment is returned.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetByPatientIdAsync_OrderedByDateDescending()
    {
        // TODO: Seed one patient with two appointments on different days.
        //       Call GetByPatientIdAsync.
        //       Assert the newer appointment is first in the result list.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // CreateAsync
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task CreateAsync_ValidRequest_SavesRecordAndReturnsDto()
    {
        // TODO: Seed a Patient.
        //       Build a CreateAppointmentRequest referencing that patient.
        //       Call CreateAsync(request, createdBy: 1).
        //       Assert the returned DTO has a non-zero AppointmentId.
        //       Assert a record exists in the database with matching fields.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task CreateAsync_DtoIncludesPatientFullName()
    {
        // TODO: Seed a Patient with known FirstName / LastName.
        //       Create an appointment for that patient.
        //       Assert result.PatientFullName == "FirstName LastName".
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // UpdateAsync
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task UpdateAsync_ExistingAppointment_PersistsChangesAndReturnsDto()
    {
        // TODO: Seed a Patient and an Appointment.
        //       Build an UpdateAppointmentRequest with changed field values.
        //       Call UpdateAsync(appointment.AppointmentId, request).
        //       Assert the returned DTO reflects the updated values.
        //       Reload the entity and assert persistence.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task UpdateAsync_MissingId_ReturnsNull()
    {
        // TODO: Call UpdateAsync with a non-existent id.
        //       Assert the result is null (no exception thrown).
        throw new NotImplementedException("Replace this with your real test body.");
    }
}
