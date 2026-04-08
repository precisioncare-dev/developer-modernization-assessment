using PrecisionCare.Api.Data;
using PrecisionCare.Api.DTOs.Patients;

namespace PrecisionCare.Api.Services;

public class PatientService(AppDbContext db) : IPatientService
{
    public async Task<IEnumerable<PatientDto>> GetAllAsync(string? search = null)
    {
        // TODO: Query db.Patients using EF Core (AsNoTracking for read-only queries).
        // If `search` is provided, filter by first or last name using a
        // parameterized LIKE — never concatenate raw input into a SQL string.
        // Order results by last name then first name, and project to PatientDto.
        throw new NotImplementedException();
    }

    public async Task<PatientDto?> GetByIdAsync(int id)
    {
        // TODO: Return the patient matching `id` as a PatientDto, or null if not found.
        throw new NotImplementedException();
    }

    public async Task<PatientDto> CreateAsync(CreatePatientRequest request, int createdBy)
    {
        // TODO: Map the request to a new Patient entity, set CreatedBy = createdBy,
        // persist via db.Patients.Add + SaveChangesAsync, and return a PatientDto.
        throw new NotImplementedException();
    }

    public async Task<PatientDto?> UpdateAsync(int id, UpdatePatientRequest request)
    {
        // TODO: Load the patient by id, apply all fields from the request,
        // set UpdatedAt = DateTime.UtcNow, save, and return the updated PatientDto.
        // Return null if the patient does not exist.
        throw new NotImplementedException();
    }

    public async Task<bool> DeleteAsync(int id)
    {
        // TODO: Delete the patient with the given id and return true on success,
        // false if not found.
        throw new NotImplementedException();
    }
}
