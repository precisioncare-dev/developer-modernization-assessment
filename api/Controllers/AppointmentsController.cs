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
        var appointments = await appointmentService.GetAllAsync(status, date);
        return Ok(appointments);
    }

    /// <summary>Get a single appointment by ID.</summary>
    [HttpGet("api/appointments/{id:int}")]
    [ProducesResponseType(typeof(AppointmentDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id)
    {
        var appt = await appointmentService.GetByIdAsync(id);
        return appt is null ? NotFound() : Ok(appt);
    }

    /// <summary>Get all appointments for a specific patient.</summary>
    [HttpGet("api/patients/{patientId:int}/appointments")]
    [ProducesResponseType(typeof(IEnumerable<AppointmentDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetByPatient(int patientId)
    {
        var appointments = await appointmentService.GetByPatientIdAsync(patientId);
        return Ok(appointments);
    }

    /// <summary>Create a new appointment.</summary>
    [HttpPost("api/appointments")]
    [Authorize(Roles = "Admin,Staff")]
    [ProducesResponseType(typeof(AppointmentDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create([FromBody] CreateAppointmentRequest request)
    {
        var appt = await appointmentService.CreateAsync(request, CurrentUserId);
        return CreatedAtAction(nameof(GetById), new { id = appt.AppointmentId }, appt);
    }

    /// <summary>Update an existing appointment.</summary>
    [HttpPut("api/appointments/{id:int}")]
    [Authorize(Roles = "Admin,Staff")]
    [ProducesResponseType(typeof(AppointmentDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateAppointmentRequest request)
    {
        var appt = await appointmentService.UpdateAsync(id, request);
        return appt is null ? NotFound() : Ok(appt);
    }
}
