using System.ComponentModel.DataAnnotations;

namespace PrecisionCare.Api.DTOs.Appointments;

public class UpdateAppointmentRequest
{
    [Required]
    public int PatientId { get; set; }

    [Required]
    public DateTime AppointmentDate { get; set; }

    [Range(5, 480)]
    public int Duration { get; set; } = 30;

    [Required, MaxLength(500)]
    public string Reason { get; set; } = string.Empty;

    [Required, MaxLength(20)]
    [RegularExpression("^(Scheduled|Completed|Cancelled|NoShow)$",
        ErrorMessage = "Status must be Scheduled, Completed, Cancelled, or NoShow.")]
    public string Status { get; set; } = "Scheduled";

    [Required, MaxLength(100)]
    public string ProviderName { get; set; } = string.Empty;

    public string? Notes { get; set; }
}
