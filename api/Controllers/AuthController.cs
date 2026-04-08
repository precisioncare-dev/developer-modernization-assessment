using Microsoft.AspNetCore.Mvc;
using PrecisionCare.Api.DTOs.Auth;
using PrecisionCare.Api.Services;

namespace PrecisionCare.Api.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController(IAuthService authService) : ControllerBase
{
    /// <summary>Authenticate a user and return a JWT token.</summary>
    [HttpPost("login")]
    [ProducesResponseType(typeof(LoginResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        // TODO: Call authService.LoginAsync(request).
        // Return 200 OK with the LoginResponse on success, or 401 Unauthorized
        // with a generic error message on failure (do not reveal which field failed).
        throw new NotImplementedException();
    }
}
