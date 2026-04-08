using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PrecisionCare.Api.DTOs.Patients;
using PrecisionCare.Api.Services;

namespace PrecisionCare.Api.Controllers;

[ApiController]
[Route("api/patients")]
[Authorize]
public class PatientsController(IPatientService patientService) : ControllerBase
{
    private int CurrentUserId =>
        int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)
            ?? User.FindFirstValue("sub")
            ?? "0");

    /// <summary>Get all patients. Optionally filter by name with ?search=</summary>
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<PatientDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll([FromQuery] string? search)
    {
        // TODO: Delegate to patientService.GetAllAsync(search) and return 200 OK.
        throw new NotImplementedException();
    }

    /// <summary>Get a single patient by ID.</summary>
    [HttpGet("{id:int}")]
    [ProducesResponseType(typeof(PatientDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id)
    {
        // TODO: Return 200 OK with the patient, or 404 Not Found if absent.
        throw new NotImplementedException();
    }

    /// <summary>Create a new patient. Requires Admin or Staff role.</summary>
    [HttpPost]
    [Authorize(Roles = "Admin,Staff")]
    [ProducesResponseType(typeof(PatientDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create([FromBody] CreatePatientRequest request)
    {
        // TODO: Call patientService.CreateAsync(request, CurrentUserId).
        // Return 201 Created with a Location header pointing to the new resource.
        throw new NotImplementedException();
    }

    /// <summary>Update an existing patient. Requires Admin or Staff role.</summary>
    [HttpPut("{id:int}")]
    [Authorize(Roles = "Admin,Staff")]
    [ProducesResponseType(typeof(PatientDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Update(int id, [FromBody] UpdatePatientRequest request)
    {
        // TODO: Return 200 OK with the updated patient, or 404 Not Found.
        throw new NotImplementedException();
    }

    /// <summary>Delete a patient. Requires Admin role.</summary>
    [HttpDelete("{id:int}")]
    [Authorize(Roles = "Admin")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id)
    {
        // TODO: Return 204 No Content on success, or 404 Not Found.
        throw new NotImplementedException();
    }
}
