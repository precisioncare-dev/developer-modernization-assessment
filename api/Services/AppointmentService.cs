using Microsoft.EntityFrameworkCore;
using PrecisionCare.Api.Data;
using PrecisionCare.Api.DTOs.Appointments;
using PrecisionCare.Api.Models;

namespace PrecisionCare.Api.Services;

public class AppointmentService(AppDbContext db) : IAppointmentService
{
    public async Task<IEnumerable<AppointmentDto>> GetAllAsync(string? status = null, DateOnly? date = null)
    {
        var query = db.Appointments
            .AsNoTracking()
            .Include(a => a.Patient);

        IQueryable<Appointment> filtered = query;

        if (!string.IsNullOrWhiteSpace(status))
            filtered = filtered.Where(a => a.Status == status);

        if (date.HasValue)
            filtered = filtered.Where(a => DateOnly.FromDateTime(a.AppointmentDate) == date.Value);

        return await filtered
            .OrderBy(a => a.AppointmentDate)
            .Select(a => ToDto(a))
            .ToListAsync();
    }

    public async Task<AppointmentDto?> GetByIdAsync(int id)
    {
        var a = await db.Appointments
            .AsNoTracking()
            .Include(a => a.Patient)
            .FirstOrDefaultAsync(a => a.AppointmentId == id);
        return a is null ? null : ToDto(a);
    }

    public async Task<IEnumerable<AppointmentDto>> GetByPatientIdAsync(int patientId)
    {
        return await db.Appointments
            .AsNoTracking()
            .Include(a => a.Patient)
            .Where(a => a.PatientId == patientId)
            .OrderByDescending(a => a.AppointmentDate)
            .Select(a => ToDto(a))
            .ToListAsync();
    }

    public async Task<AppointmentDto> CreateAsync(CreateAppointmentRequest request, int createdBy)
    {
        var appointment = new Appointment
        {
            PatientId = request.PatientId,
            AppointmentDate = request.AppointmentDate,
            Duration = request.Duration,
            Reason = request.Reason,
            Status = request.Status,
            ProviderName = request.ProviderName,
            Notes = request.Notes,
            CreatedBy = createdBy
        };

        db.Appointments.Add(appointment);
        await db.SaveChangesAsync();

        await db.Entry(appointment).Reference(a => a.Patient).LoadAsync();
        return ToDto(appointment);
    }

    public async Task<AppointmentDto?> UpdateAsync(int id, UpdateAppointmentRequest request)
    {
        var appointment = await db.Appointments
            .Include(a => a.Patient)
            .FirstOrDefaultAsync(a => a.AppointmentId == id);

        if (appointment is null) return null;

        appointment.PatientId = request.PatientId;
        appointment.AppointmentDate = request.AppointmentDate;
        appointment.Duration = request.Duration;
        appointment.Reason = request.Reason;
        appointment.Status = request.Status;
        appointment.ProviderName = request.ProviderName;
        appointment.Notes = request.Notes;

        await db.SaveChangesAsync();
        return ToDto(appointment);
    }

    private static AppointmentDto ToDto(Appointment a) => new()
    {
        AppointmentId = a.AppointmentId,
        PatientId = a.PatientId,
        PatientFullName = a.Patient is not null
            ? $"{a.Patient.FirstName} {a.Patient.LastName}"
            : string.Empty,
        AppointmentDate = a.AppointmentDate,
        Duration = a.Duration,
        Reason = a.Reason,
        Status = a.Status,
        ProviderName = a.ProviderName,
        Notes = a.Notes,
        CreatedAt = a.CreatedAt
    };
}
