using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PrecisionCare.Api.DTOs.Appointments;
using PrecisionCare.Api.Services;

namespace PrecisionCare.Api.Controllers;

[ApiController]
[Authorize]
public class AppointmentsController(IAppointmentService appointmentService) : ControllerBase
{
    private int CurrentUserId =>
        int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)
            ?? User.FindFirstValue("sub")
            ?? "0");

    /// <summary>Get all appointments. Filter by ?status= and/or ?date= (yyyy-MM-dd).</summary>
    [HttpGet("api/appointments")]
    [ProducesResponseType(typeof(IEnumerable<AppointmentDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll([FromQuery] string? status, [FromQuery] DateOnly? date)
    {
        // TODO: Return 200 OK with the filtered appointment list.
        throw new NotImplementedException();
    }

    /// <summary>Get a single appointment by ID.</summary>
    [HttpGet("api/appointments/{id:int}")]
    [ProducesResponseType(typeof(AppointmentDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id)
    {
        // TODO: Return 200 OK with the appointment, or 404 Not Found.
        throw new NotImplementedException();
    }

    /// <summary>Get all appointments for a specific patient.</summary>
    [HttpGet("api/patients/{patientId:int}/appointments")]
    [ProducesResponseType(typeof(IEnumerable<AppointmentDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetByPatient(int patientId)
    {
        // TODO: Return 200 OK with all appointments for the patient.
        throw new NotImplementedException();
    }

    /// <summary>Create a new appointment. Requires Admin or Staff role.</summary>
    [HttpPost("api/appointments")]
    [Authorize(Roles = "Admin,Staff")]
    [ProducesResponseType(typeof(AppointmentDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create([FromBody] CreateAppointmentRequest request)
    {
        // TODO: Call appointmentService.CreateAsync(request, CurrentUserId).
        // Return 201 Created with a Location header.
        throw new NotImplementedException();
    }

    /// <summary>Update an existing appointment. Requires Admin or Staff role.</summary>
    [HttpPut("api/appointments/{id:int}")]
    [Authorize(Roles = "Admin,Staff")]
    [ProducesResponseType(typeof(AppointmentDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateAppointmentRequest request)
    {
        // TODO: Return 200 OK with the updated appointment, or 404 Not Found.
        throw new NotImplementedException();
    }
}
