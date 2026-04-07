using PrecisionCare.Api.DTOs.Auth;

namespace PrecisionCare.Api.Services;

public interface IAuthService
{
    Task<LoginResponse?> LoginAsync(LoginRequest request);
}
