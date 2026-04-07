using PrecisionCare.Api.DTOs.Appointments;

namespace PrecisionCare.Api.Services;

public interface IAppointmentService
{
    Task<IEnumerable<AppointmentDto>> GetAllAsync(string? status = null, DateOnly? date = null);
    Task<AppointmentDto?> GetByIdAsync(int id);
    Task<IEnumerable<AppointmentDto>> GetByPatientIdAsync(int patientId);
    Task<AppointmentDto> CreateAsync(CreateAppointmentRequest request, int createdBy);
    Task<AppointmentDto?> UpdateAsync(int id, UpdateAppointmentRequest request);
}
