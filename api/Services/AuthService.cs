using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using PrecisionCare.Api.Data;
using PrecisionCare.Api.DTOs.Auth;

namespace PrecisionCare.Api.Services;

public class AuthService(AppDbContext db, IConfiguration config) : IAuthService
{
    public async Task<LoginResponse?> LoginAsync(LoginRequest request)
    {
        var user = await db.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(u => u.Username == request.Username && u.IsActive);

        if (user is null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
            return null;

        // Update LastLogin — use a tracked update to avoid a full round-trip
        await db.Users
            .Where(u => u.UserId == user.UserId)
            .ExecuteUpdateAsync(s => s.SetProperty(u => u.LastLogin, DateTime.UtcNow));

        var token = GenerateJwt(user.UserId, user.Username, user.FullName, user.Role);
        var expiresAt = DateTime.UtcNow.AddMinutes(GetExpiryMinutes());

        return new LoginResponse
        {
            Token = token,
            Username = user.Username,
            FullName = user.FullName,
            Role = user.Role,
            ExpiresAt = expiresAt
        };
    }

    private string GenerateJwt(int userId, string username, string fullName, string role)
    {
        var jwtSettings = config.GetSection("JwtSettings");
        var key = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(jwtSettings["SecretKey"]
                ?? throw new InvalidOperationException("JWT SecretKey is not configured.")));

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, userId.ToString()),
            new(JwtRegisteredClaimNames.UniqueName, username),
            new("fullName", fullName),
            new(ClaimTypes.Role, role),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        var token = new JwtSecurityToken(
            issuer: jwtSettings["Issuer"],
            audience: jwtSettings["Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(GetExpiryMinutes()),
            signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256));

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    private int GetExpiryMinutes()
    {
        var raw = config["JwtSettings:ExpiryMinutes"];
        return int.TryParse(raw, out var minutes) ? minutes : 60;
    }
}
