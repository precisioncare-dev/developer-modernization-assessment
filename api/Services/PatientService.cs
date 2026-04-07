using Microsoft.EntityFrameworkCore;
using PrecisionCare.Api.Data;
using PrecisionCare.Api.DTOs.Patients;
using PrecisionCare.Api.Models;

namespace PrecisionCare.Api.Services;

public class PatientService(AppDbContext db) : IPatientService
{
    public async Task<IEnumerable<PatientDto>> GetAllAsync(string? search = null)
    {
        var query = db.Patients.AsNoTracking();

        if (!string.IsNullOrWhiteSpace(search))
        {
            var term = search.Trim().ToLower();
            // EF Core translates this to a parameterized LIKE — no SQL injection
            query = query.Where(p =>
                p.LastName.ToLower().Contains(term) ||
                p.FirstName.ToLower().Contains(term));
        }

        return await query
            .OrderBy(p => p.LastName).ThenBy(p => p.FirstName)
            .Select(p => ToDto(p))
            .ToListAsync();
    }

    public async Task<PatientDto?> GetByIdAsync(int id)
    {
        var p = await db.Patients.AsNoTracking().FirstOrDefaultAsync(p => p.PatientId == id);
        return p is null ? null : ToDto(p);
    }

    public async Task<PatientDto> CreateAsync(CreatePatientRequest request, int createdBy)
    {
        var patient = new Patient
        {
            FirstName = request.FirstName,
            LastName = request.LastName,
            DateOfBirth = request.DateOfBirth,
            Gender = request.Gender,
            Email = request.Email,
            Phone = request.Phone,
            Address = request.Address,
            City = request.City,
            State = request.State,
            ZipCode = request.ZipCode,
            InsuranceId = request.InsuranceId,
            Notes = request.Notes,
            CreatedBy = createdBy
        };

        db.Patients.Add(patient);
        await db.SaveChangesAsync();
        return ToDto(patient);
    }

    public async Task<PatientDto?> UpdateAsync(int id, UpdatePatientRequest request)
    {
        var patient = await db.Patients.FindAsync(id);
        if (patient is null) return null;

        patient.FirstName = request.FirstName;
        patient.LastName = request.LastName;
        patient.DateOfBirth = request.DateOfBirth;
        patient.Gender = request.Gender;
        patient.Email = request.Email;
        patient.Phone = request.Phone;
        patient.Address = request.Address;
        patient.City = request.City;
        patient.State = request.State;
        patient.ZipCode = request.ZipCode;
        patient.InsuranceId = request.InsuranceId;
        patient.Notes = request.Notes;
        patient.UpdatedAt = DateTime.UtcNow;

        await db.SaveChangesAsync();
        return ToDto(patient);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var affected = await db.Patients.Where(p => p.PatientId == id).ExecuteDeleteAsync();
        return affected > 0;
    }

    private static PatientDto ToDto(Patient p) => new()
    {
        PatientId = p.PatientId,
        FirstName = p.FirstName,
        LastName = p.LastName,
        DateOfBirth = p.DateOfBirth,
        Gender = p.Gender,
        Email = p.Email,
        Phone = p.Phone,
        Address = p.Address,
        City = p.City,
        State = p.State,
        ZipCode = p.ZipCode,
        InsuranceId = p.InsuranceId,
        Notes = p.Notes,
        CreatedAt = p.CreatedAt,
        UpdatedAt = p.UpdatedAt
    };
}
