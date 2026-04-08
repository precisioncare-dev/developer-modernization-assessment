using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using PrecisionCare.Api.Controllers;
using PrecisionCare.Api.DTOs.Patients;
using PrecisionCare.Api.Services;
using System.Security.Claims;
using Xunit;

namespace PrecisionCare.Api.Tests.Controllers;

// =============================================================================
// PatientsControllerTests
// =============================================================================
// Grading rubric contribution: Code Quality & Practices — Unit Testing (see README)
//
// Controller tests verify HTTP behaviour only.  Business logic is covered by
// PatientServiceTests.  Mock IPatientService so no database is required.
//
// Extra setup required: PatientsController reads the current user ID from
// HttpContext.User claims.  Helper below shows how to inject a fake identity.
//
// Pattern
// -------
//   var mockService = new Mock<IPatientService>();
//   var controller  = new PatientsController(mockService.Object);
//
//   // Inject a fake authenticated user (userId = 7, role = "Admin"):
//   controller.ControllerContext = BuildControllerContext(userId: 7, role: "Admin");
//
// Required coverage
// -----------------
//   ✔  GetAll   — service returns list    → 200 OK with list
//   ✔  GetById  — patient found           → 200 OK
//   ✔  GetById  — patient not found       → 404 Not Found
//   ✔  Create   — valid request           → 201 Created with Location header
//   ✔  Update   — patient found           → 200 OK with updated DTO
//   ✔  Update   — patient not found       → 404 Not Found
//   ✔  Delete   — patient deleted         → 204 No Content
//   ✔  Delete   — patient not found       → 404 Not Found
// =============================================================================

public class PatientsControllerTests
{
    // -------------------------------------------------------------------------
    // Helper — build a ControllerContext with a fake authenticated user.
    // -------------------------------------------------------------------------
    private static ControllerContext BuildControllerContext(int userId = 1, string role = "Admin")
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

    private readonly Mock<IPatientService> _mockService = new();

    // TODO: Optionally initialise the controller once here:
    //   private readonly PatientsController _controller;
    //   public PatientsControllerTests()
    //   {
    //       _controller = new PatientsController(_mockService.Object);
    //       _controller.ControllerContext = BuildControllerContext();
    //   }

    // =========================================================================
    // GetAll
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAll_ServiceReturnsPatients_Returns200OkWithList()
    {
        // TODO: Setup _mockService.GetAllAsync to return a list of PatientDtos.
        //       Call controller.GetAll(search: null).
        //       Assert 200 OK and the body matches the mocked list.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetAll_WithSearchTerm_PassesSearchToService()
    {
        // TODO: Call controller.GetAll(search: "Smith").
        //       Verify _mockService.GetAllAsync was called with "Smith"
        //       using _mockService.Verify(s => s.GetAllAsync("Smith"), Times.Once).
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // GetById
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetById_PatientExists_Returns200Ok()
    {
        // TODO: Setup service to return a PatientDto for id = 1.
        //       Assert 200 OK with the correct DTO.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task GetById_PatientNotFound_Returns404NotFound()
    {
        // TODO: Setup service to return null.
        //       Assert the result is NotFoundResult.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // Create
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task Create_ValidRequest_Returns201CreatedWithLocationHeader()
    {
        // TODO: Setup service.CreateAsync to return a new PatientDto with PatientId = 5.
        //       Call controller.Create(request).
        //       Assert 201 CreatedAtActionResult.
        //       Assert routeValues["id"] == 5.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // Update
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task Update_PatientExists_Returns200OkWithUpdatedDto()
    {
        // TODO: Setup service.UpdateAsync to return an updated PatientDto.
        //       Assert 200 OK with the DTO.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task Update_PatientNotFound_Returns404NotFound()
    {
        // TODO: Setup service.UpdateAsync to return null.
        //       Assert 404 Not Found.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // Delete
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task Delete_PatientDeleted_Returns204NoContent()
    {
        // TODO: Setup service.DeleteAsync to return true.
        //       Assert 204 NoContentResult.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    [Fact(Skip = "TODO — implement this test")]
    public async Task Delete_PatientNotFound_Returns404NotFound()
    {
        // TODO: Setup service.DeleteAsync to return false.
        //       Assert 404 Not Found.
        throw new NotImplementedException("Replace this with your real test body.");
    }
}
