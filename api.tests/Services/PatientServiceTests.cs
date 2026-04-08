using FluentAssertions;
using Moq;
using PrecisionCare.Api.DTOs.Patients;
using PrecisionCare.Api.Services;
using Xunit;

namespace PrecisionCare.Api.Tests.Services;

// =============================================================================
// PatientServiceTests
// =============================================================================
// Grading rubric contribution: Code Quality & Practices — Unit Testing (see README)
//
// These tests verify PatientService in isolation. Use an EF Core in-memory
// database (UseInMemoryDatabase) as the fake data store — it is simpler than
// mocking DbSet and behaves correctly for LINQ queries.
//
// Pattern to follow
// -----------------
//   1. Create an AppDbContext backed by UseInMemoryDatabase(Guid.NewGuid().ToString()).
//   2. Seed a small, predictable data set directly into context.Patients.
//   3. new PatientService(context) → your system under test.
//   4. Call a service method and assert on the returned DTOs.
//   5. For write operations, also verify the database state after the call.
//
// Required coverage (minimum — add more tests to earn full marks)
// ---------------------------------------------------------------
//   ✔  GetAllAsync — no search term    → returns all patients ordered by LastName then FirstName
//   ✔  GetAllAsync — with search term  → filters correctly (partial name, case-insensitive)
//   ✔  GetAllAsync — search yields 0   → returns empty collection (not null)
//   ✔  GetByIdAsync — existing id      → returns correct PatientDto
//   ✔  GetByIdAsync — missing id       → returns null
//   ✔  CreateAsync                     → saves record, returns DTO with assigned PatientId
//   ✔  UpdateAsync — existing patient  → persists changes, returns updated DTO
//   ✔  UpdateAsync — missing id        → returns null, database unchanged
//   ✔  DeleteAsync — existing id       → removes record, returns true
//   ✔  DeleteAsync — missing id        → returns false, no database error
// =============================================================================

public class PatientServiceTests
{
    // TODO: Declare shared helpers / factory methods here.
    //
    // Example helpers you will likely need:
    //
    //   private static AppDbContext CreateContext() =>
    //       new(new DbContextOptionsBuilder<AppDbContext>()
    //           .UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
    //
    //   private static Patient SamplePatient(int id = 1) => new()
    //   {
    //       PatientId = id, FirstName = "Jane", LastName = "Smith",
    //       DateOfBirth = new DateOnly(1985, 6, 15), Gender = "Female"
    //   };

    // =========================================================================
    // GetAllAsync
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAllAsync_NoSearch_ReturnsAllPatientsOrderedByName()
    {
        // TODO: Seed two or more patients with different LastName values.
        //       Call GetAllAsync(search: null).
        //       Assert count and that the first result has the alphabetically
        //       earlier LastName.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAllAsync_SearchMatchesLastName_ReturnsFilteredResults()
    {
        // TODO: Seed patients "Alice Adams" and "Bob Baker".
        //       Call GetAllAsync("Adams").
        //       Assert only Alice Adams is returned.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAllAsync_SearchCaseInsensitive_ReturnsResults()
    {
        // TODO: Seed patient "Charlie Chen".
        //       Call GetAllAsync("CHEN").
        //       Assert the patient is still returned (case must not matter).
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAllAsync_SearchYieldsNoMatches_ReturnsEmptyCollection()
    {
        // TODO: Seed at least one patient.
        //       Call GetAllAsync("ZZZNoMatch").
        //       Assert the result is an empty, non-null collection.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // GetByIdAsync
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetByIdAsync_ExistingId_ReturnsCorrectDto()
    {
        // TODO: Seed a patient and call GetByIdAsync with its id.
        //       Assert all DTO fields match the seeded entity.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetByIdAsync_MissingId_ReturnsNull()
    {
        // TODO: Call GetByIdAsync with an id that does not exist in the database.
        //       Assert the result is null.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // CreateAsync
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task CreateAsync_ValidRequest_SavesRecordAndReturnsDto()
    {
        // TODO: Call CreateAsync with a fully populated CreatePatientRequest.
        //       Assert:
        //         - Returned DTO has a non-zero PatientId.
        //         - A record exists in the database with the same PatientId.
        //         - FirstName and LastName on the DTO match the request.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task CreateAsync_SetsCreatedByFromParameter()
    {
        // TODO: Call CreateAsync(request, createdBy: 42).
        //       Query the database directly for the saved Patient entity.
        //       Assert entity.CreatedBy == 42.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // UpdateAsync
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task UpdateAsync_ExistingPatient_PersistsChangesAndReturnsDto()
    {
        // TODO: Seed a patient.
        //       Build an UpdatePatientRequest with changed field values.
        //       Call UpdateAsync(patient.PatientId, request).
        //       Assert the returned DTO reflects the changes.
        //       Also reload the entity from the database and verify persistence.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task UpdateAsync_ExistingPatient_SetsUpdatedAtTimestamp()
    {
        // TODO: Seed a patient whose UpdatedAt is null.
        //       Call UpdateAsync.
        //       Assert UpdatedAt on the database entity is non-null and
        //       approximately equal to DateTime.UtcNow.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task UpdateAsync_MissingId_ReturnsNull()
    {
        // TODO: Call UpdateAsync with an id that does not exist.
        //       Assert the result is null and the database is still empty.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // DeleteAsync
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task DeleteAsync_ExistingId_RemovesRecordAndReturnsTrue()
    {
        // TODO: Seed a patient.
        //       Call DeleteAsync(patient.PatientId).
        //       Assert the return value is true.
        //       Assert no Patient records remain in the database.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task DeleteAsync_MissingId_ReturnsFalse()
    {
        // TODO: Call DeleteAsync with a non-existent id.
        //       Assert the return value is false (no exception thrown).
        throw new NotImplementedException("Replace this with your real test body.");
    }
}
