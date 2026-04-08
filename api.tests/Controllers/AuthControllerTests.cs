using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Moq;
using PrecisionCare.Api.Controllers;
using PrecisionCare.Api.DTOs.Auth;
using PrecisionCare.Api.Services;
using Xunit;

namespace PrecisionCare.Api.Tests.Controllers;

// =============================================================================
// AuthControllerTests
// =============================================================================
// Grading rubric contribution: Code Quality & Practices — Unit Testing (see README)
//
// Controller tests verify HTTP behaviour, not business logic.
// Use Moq to replace IAuthService so the service is fully faked.
//
// Pattern
// -------
//   1. var mockAuthService = new Mock<IAuthService>();
//   2. mockAuthService.Setup(s => s.LoginAsync(It.IsAny<LoginRequest>()))
//          .ReturnsAsync(/* LoginResponse or null */);
//   3. var controller = new AuthController(mockAuthService.Object);
//   4. var result = await controller.Login(request);
//   5. Assert the IActionResult type and content.
//
// Required coverage
// -----------------
//   ✔  Login — service returns LoginResponse → 200 OK with the response body
//   ✔  Login — service returns null          → 401 Unauthorized with error message
//   ✔  Login — invalid model state           → 400 Bad Request (use controller.ModelState)
// =============================================================================

public class AuthControllerTests
{
    private readonly Mock<IAuthService> _mockAuthService = new();

    // TODO: Optionally initialise the controller here:
    //   private readonly AuthController _controller;
    //   public AuthControllerTests() =>
    //       _controller = new AuthController(_mockAuthService.Object);

    // =========================================================================
    // Login — success
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task Login_ValidCredentials_Returns200OkWithToken()
    {
        // TODO: Arrange
        //   _mockAuthService
        //       .Setup(s => s.LoginAsync(It.IsAny<LoginRequest>()))
        //       .ReturnsAsync(new LoginResponse { Token = "jwt-token", ... });
        //
        // TODO: Act
        //   var result = await _controller.Login(new LoginRequest { ... });
        //
        // TODO: Assert
        //   var ok = result.Should().BeOfType<OkObjectResult>().Subject;
        //   var body = ok.Value.Should().BeOfType<LoginResponse>().Subject;
        //   body.Token.Should().NotBeNullOrWhiteSpace();
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // Login — wrong credentials
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task Login_InvalidCredentials_Returns401Unauthorized()
    {
        // TODO: Arrange
        //   _mockAuthService
        //       .Setup(s => s.LoginAsync(It.IsAny<LoginRequest>()))
        //       .ReturnsAsync((LoginResponse?)null);
        //
        // TODO: Act / Assert
        //   result.Should().BeOfType<UnauthorizedObjectResult>();
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // Login — invalid model state
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task Login_InvalidModelState_Returns400BadRequest()
    {
        // TODO: Arrange
        //   Simulate a model-validation failure:
        //     _controller.ModelState.AddModelError("Username", "Required");
        //
        // TODO: Act / Assert
        //   result.Should().BeOfType<BadRequestObjectResult>();
        //
        // NOTE: In real ASP.NET Core the framework validates the model before
        // calling the action.  To simulate this in a unit test, either check
        // ModelState.IsValid at the top of the action, or use WebApplicationFactory
        // for a full integration test.
        throw new NotImplementedException("Replace this with your real test body.");
    }
}
