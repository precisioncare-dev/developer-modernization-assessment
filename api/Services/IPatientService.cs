using PrecisionCare.Api.DTOs.Patients;

namespace PrecisionCare.Api.Services;

public interface IPatientService
{
    Task<IEnumerable<PatientDto>> GetAllAsync(string? search = null);
    Task<PatientDto?> GetByIdAsync(int id);
    Task<PatientDto> CreateAsync(CreatePatientRequest request, int createdBy);
    Task<PatientDto?> UpdateAsync(int id, UpdatePatientRequest request);
    Task<bool> DeleteAsync(int id);
}
