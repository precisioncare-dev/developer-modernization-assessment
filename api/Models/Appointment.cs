namespace PrecisionCare.Api.Models;

public class Appointment
{
    public int AppointmentId { get; set; }
    public int PatientId { get; set; }
    public DateTime AppointmentDate { get; set; }
    public int Duration { get; set; } = 30; // minutes
    public string Reason { get; set; } = string.Empty;
    public string Status { get; set; } = "Scheduled"; // Scheduled | Completed | Cancelled | NoShow
    public string ProviderName { get; set; } = string.Empty;
    public string? Notes { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public int? CreatedBy { get; set; }

    public Patient Patient { get; set; } = null!;
    public User? Creator { get; set; }
}
