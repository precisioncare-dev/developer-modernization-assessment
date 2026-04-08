using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using PrecisionCare.Api.Controllers;
using PrecisionCare.Api.DTOs.Appointments;
using PrecisionCare.Api.Services;
using System.Security.Claims;
using Xunit;

namespace PrecisionCare.Api.Tests.Controllers;

// =============================================================================
// AppointmentsControllerTests
// =============================================================================
// Grading rubric contribution: Code Quality & Practices — Unit Testing (see README)
//
// These tests cover the HTTP layer only — mock IAppointmentService completely
// so no database or real service code executes.
//
// Required coverage
// -----------------
//   ✔  GetAll   — no filters             → 200 OK with full list
//   ✔  GetAll   — status filter passed   → service called with correct args
//   ✔  GetById  — appointment found      → 200 OK
//   ✔  GetById  — not found              → 404 Not Found
//   ✔  GetByPatient — returns list       → 200 OK
//   ✔  Create   — valid request          → 201 Created
//   ✔  Update   — appointment found      → 200 OK
//   ✔  Update   — not found              → 404 Not Found
// =============================================================================

public class AppointmentsControllerTests
{
    // -------------------------------------------------------------------------
    // Helper — build a ControllerContext with a fake authenticated user.
    // (Same pattern as PatientsControllerTests — consider extracting to a
    //  shared TestHelpers class to avoid duplication.)
    // -------------------------------------------------------------------------
    private static ControllerContext BuildControllerContext(int userId = 1, string role = "Staff")
    {
        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, userId.ToString()),
            new Claim(ClaimTypes.Role, role)
        };
        var identity  = new ClaimsIdentity(claims, authenticationType: "Test");
        var principal = new ClaimsPrincipal(identity);

        return new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = principal }
        };
    }

    private readonly Mock<IAppointmentService> _mockService = new();

    // TODO: Optionally create the controller once in the constructor.

    // =========================================================================
    // GetAll
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAll_NoFilters_Returns200OkWithList()
    {
        // TODO: Setup _mockService.GetAllAsync(null, null) to return a list.
        //       Assert 200 OK with that list in the body.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAll_StatusFilter_PassesFilterToService()
    {
        // TODO: Call controller.GetAll(status: "Scheduled", date: null).
        //       Verify _mockService.GetAllAsync was called with "Scheduled".
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // GetById
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetById_AppointmentExists_Returns200Ok()
    {
        // TODO: Setup service to return an AppointmentDto.
        //       Assert 200 OK.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetById_NotFound_Returns404NotFound()
    {
        // TODO: Setup service to return null.
        //       Assert 404 Not Found.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // GetByPatient
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetByPatient_Returns200OkWithAppointmentList()
    {
        // TODO: Setup _mockService.GetByPatientIdAsync(42) to return a list.
        //       Call controller.GetByPatient(patientId: 42).
        //       Assert 200 OK and the body matches the mocked list.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // Create
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task Create_ValidRequest_Returns201Created()
    {
        // TODO: Setup service.CreateAsync to return an AppointmentDto with AppointmentId = 10.
        //       Call controller.Create(request).
        //       Assert 201 CreatedAtActionResult.
        //       Assert routeValues["id"] == 10.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // Update
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task Update_AppointmentExists_Returns200Ok()
    {
        // TODO: Setup service.UpdateAsync to return an updated AppointmentDto.
        //       Assert 200 OK with the DTO.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task Update_NotFound_Returns404NotFound()
    {
        // TODO: Setup service.UpdateAsync to return null.
        //       Assert 404 Not Found.
        throw new NotImplementedException("Replace this with your real test body.");
    }
}
