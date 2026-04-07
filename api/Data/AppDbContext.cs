using Microsoft.EntityFrameworkCore;
using PrecisionCare.Api.Models;

namespace PrecisionCare.Api.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<User> Users => Set<User>();
    public DbSet<Patient> Patients => Set<Patient>();
    public DbSet<Appointment> Appointments => Set<Appointment>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<User>(e =>
        {
            e.ToTable("Users");
            e.HasKey(u => u.UserId);
            e.Property(u => u.UserId).HasColumnName("UserID");
            e.Property(u => u.Username).HasMaxLength(50).IsRequired();
            e.HasIndex(u => u.Username).IsUnique();
            e.Property(u => u.PasswordHash).HasColumnName("PasswordHash").HasMaxLength(256).IsRequired();
            e.Property(u => u.FullName).HasMaxLength(100).IsRequired();
            e.Property(u => u.Email).HasMaxLength(150).IsRequired();
            e.Property(u => u.Role).HasMaxLength(20).HasDefaultValue("Staff");
            e.Property(u => u.IsActive).HasDefaultValue(true);
            e.Property(u => u.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
        });

        modelBuilder.Entity<Patient>(e =>
        {
            e.ToTable("Patients");
            e.HasKey(p => p.PatientId);
            e.Property(p => p.PatientId).HasColumnName("PatientID");
            e.Property(p => p.FirstName).HasMaxLength(50).IsRequired();
            e.Property(p => p.LastName).HasMaxLength(50).IsRequired();
            e.Property(p => p.Gender).HasMaxLength(10).IsRequired();
            e.Property(p => p.Email).HasMaxLength(150);
            e.Property(p => p.Phone).HasMaxLength(20);
            e.Property(p => p.Address).HasMaxLength(250);
            e.Property(p => p.City).HasMaxLength(100);
            e.Property(p => p.State).HasMaxLength(50);
            e.Property(p => p.ZipCode).HasMaxLength(10);
            e.Property(p => p.InsuranceId).HasColumnName("InsuranceID").HasMaxLength(50);
            e.Property(p => p.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            e.HasOne(p => p.Creator).WithMany(u => u.CreatedPatients)
                .HasForeignKey(p => p.CreatedBy).OnDelete(DeleteBehavior.SetNull);
        });

        modelBuilder.Entity<Appointment>(e =>
        {
            e.ToTable("Appointments");
            e.HasKey(a => a.AppointmentId);
            e.Property(a => a.AppointmentId).HasColumnName("AppointmentID");
            e.Property(a => a.PatientId).HasColumnName("PatientID");
            e.Property(a => a.Duration).HasDefaultValue(30);
            e.Property(a => a.Reason).HasMaxLength(500).IsRequired();
            e.Property(a => a.Status).HasMaxLength(20).HasDefaultValue("Scheduled");
            e.Property(a => a.ProviderName).HasMaxLength(100).IsRequired();
            e.Property(a => a.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            e.HasOne(a => a.Patient).WithMany(p => p.Appointments)
                .HasForeignKey(a => a.PatientId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne(a => a.Creator).WithMany(u => u.CreatedAppointments)
                .HasForeignKey(a => a.CreatedBy).OnDelete(DeleteBehavior.SetNull);
        });
    }
}
