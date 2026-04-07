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
        var patients = await patientService.GetAllAsync(search);
        return Ok(patients);
    }

    /// <summary>Get a single patient by ID.</summary>
    [HttpGet("{id:int}")]
    [ProducesResponseType(typeof(PatientDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id)
    {
        var patient = await patientService.GetByIdAsync(id);
        return patient is null ? NotFound() : Ok(patient);
    }

    /// <summary>Create a new patient.</summary>
    [HttpPost]
    [Authorize(Roles = "Admin,Staff")]
    [ProducesResponseType(typeof(PatientDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create([FromBody] CreatePatientRequest request)
    {
        var patient = await patientService.CreateAsync(request, CurrentUserId);
        return CreatedAtAction(nameof(GetById), new { id = patient.PatientId }, patient);
    }

    /// <summary>Update an existing patient.</summary>
    [HttpPut("{id:int}")]
    [Authorize(Roles = "Admin,Staff")]
    [ProducesResponseType(typeof(PatientDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Update(int id, [FromBody] UpdatePatientRequest request)
    {
        var patient = await patientService.UpdateAsync(id, request);
        return patient is null ? NotFound() : Ok(patient);
    }

    /// <summary>Delete a patient. Admin only.</summary>
    [HttpDelete("{id:int}")]
    [Authorize(Roles = "Admin")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await patientService.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();
    }
}
