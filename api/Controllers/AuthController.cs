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
        var response = await authService.LoginAsync(request);
        if (response is null)
            return Unauthorized(new { message = "Invalid username or password." });

        return Ok(response);
    }
}
