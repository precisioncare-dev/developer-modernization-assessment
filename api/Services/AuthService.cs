using PrecisionCare.Api.Data;
using PrecisionCare.Api.DTOs.Auth;

namespace PrecisionCare.Api.Services;

public class AuthService(AppDbContext db, IConfiguration config) : IAuthService
{
    public async Task<LoginResponse?> LoginAsync(LoginRequest request)
    {
        // TODO: Implement authentication logic:
        // 1. Look up the user by username — only consider active accounts
        // 2. Verify the provided password against the stored bcrypt hash
        //    (NEVER compare plain-text passwords)
        // 3. Update the user's LastLogin timestamp
        // 4. Generate a signed JWT containing the user's id, username, full
        //    name, and role; read signing key / issuer / audience / expiry from
        //    IConfiguration ("JwtSettings" section in appsettings.json)
        // 5. Return a LoginResponse with the token and user metadata, or null
        //    if authentication fails (do NOT reveal which field was wrong)
        throw new NotImplementedException();
    }
}
