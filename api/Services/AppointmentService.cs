using PrecisionCare.Api.Data;
using PrecisionCare.Api.DTOs.Appointments;

namespace PrecisionCare.Api.Services;

public class AppointmentService(AppDbContext db) : IAppointmentService
{
    public async Task<IEnumerable<AppointmentDto>> GetAllAsync(string? status = null, DateOnly? date = null)
    {
        // TODO: Query db.Appointments (Include the related Patient).
        // Apply optional filters for status and date when provided.
        // Order by AppointmentDate ascending and project to AppointmentDto.
        throw new NotImplementedException();
    }

    public async Task<AppointmentDto?> GetByIdAsync(int id)
    {
        // TODO: Return the appointment with the matching id (Include Patient),
        // or null if not found.
        throw new NotImplementedException();
    }

    public async Task<IEnumerable<AppointmentDto>> GetByPatientIdAsync(int patientId)
    {
        // TODO: Return all appointments for the specified patient, ordered by
        // AppointmentDate descending.
        throw new NotImplementedException();
    }

    public async Task<AppointmentDto> CreateAsync(CreateAppointmentRequest request, int createdBy)
    {
        // TODO: Map the request to a new Appointment entity, set CreatedBy,
        // persist via SaveChangesAsync, eager-load the Patient navigation,
        // and return an AppointmentDto.
        throw new NotImplementedException();
    }

    public async Task<AppointmentDto?> UpdateAsync(int id, UpdateAppointmentRequest request)
    {
        // TODO: Load the appointment by id (Include Patient), apply all fields
        // from the request, save, and return the updated AppointmentDto.
        // Return null if the appointment does not exist.
        throw new NotImplementedException();
    }
}
