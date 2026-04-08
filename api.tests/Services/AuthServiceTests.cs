using FluentAssertions;
using Moq;
using PrecisionCare.Api.DTOs.Auth;
using PrecisionCare.Api.Services;
using Xunit;

namespace PrecisionCare.Api.Tests.Services;

// =============================================================================
// AuthServiceTests
// =============================================================================
// Grading rubric contribution: Code Quality & Practices — Unit Testing (see README)
//
// These tests cover the AuthService business logic in complete isolation from
// the database.  Use Moq to replace AppDbContext with an in-memory fake so
// tests run without a real SQL Server instance.
//
// Recommended approach
// --------------------
//   1. Build a small set of in-memory User records.
//   2. Set up a Mock<AppDbContext> (or use EF Core's UseInMemoryDatabase) so
//      that db.Users returns those records.
//   3. Provide a real IConfiguration stub that holds JwtSettings values.
//   4. Instantiate AuthService with those fakes.
//   5. Assert the return value and any side-effects.
//
// Required coverage
// -----------------
//   ✔  Login — valid credentials  → returns a non-null LoginResponse
//   ✔  Login — wrong password     → returns null  (no exception)
//   ✔  Login — unknown username   → returns null
//   ✔  Login — inactive account   → returns null
//   ✔  LoginResponse shape        → Token is non-empty, Role matches the user record
// =============================================================================

public class AuthServiceTests
{
    // -------------------------------------------------------------------------
    // Shared setup — create once and reuse across test methods.
    // -------------------------------------------------------------------------

    // TODO: Declare a Mock<IAuthService> (or a real AuthService wired to an
    // in-memory DbContext) and a sample LoginRequest / User here so every test
    // method can share the same baseline state.
    //
    // Example:
    //   private readonly IAuthService _sut;  // system under test
    //   public AuthServiceTests() { /* set up fakes */ }

    // =========================================================================
    // LoginAsync — happy path
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task LoginAsync_ValidCredentials_ReturnsLoginResponse()
    {
        // TODO: Arrange
        //   - Create a User entity with a BCrypt-hashed password.
        //   - Set up the in-memory context so db.Users returns that user.
        //   - Build a LoginRequest with the matching plain-text password.

        // TODO: Act
        //   var result = await _sut.LoginAsync(request);

        // TODO: Assert
        //   result.Should().NotBeNull();
        //   result!.Token.Should().NotBeNullOrWhiteSpace();
        //   result.Username.Should().Be("expectedUsername");
        //   result.Role.Should().Be("expectedRole");
        //   result.ExpiresAt.Should().BeAfter(DateTime.UtcNow);
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // LoginAsync — wrong password
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task LoginAsync_WrongPassword_ReturnsNull()
    {
        // TODO: Arrange
        //   - Set up a valid user in the context.
        //   - Build a LoginRequest with the correct username but wrong password.

        // TODO: Act
        //   var result = await _sut.LoginAsync(request);

        // TODO: Assert
        //   result.Should().BeNull("a wrong password must never yield a token");
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // LoginAsync — unknown username
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task LoginAsync_UnknownUsername_ReturnsNull()
    {
        // TODO: Arrange — context has no user with the given username.

        // TODO: Act / Assert — result should be null.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // LoginAsync — inactive account
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task LoginAsync_InactiveUser_ReturnsNull()
    {
        // TODO: Arrange
        //   - Create a User entity with IsActive = false.
        //   - Build a matching LoginRequest (correct credentials).

        // TODO: Act / Assert
        //   Inactive accounts must be rejected even when the password is correct.
        throw new NotImplementedException("Replace this with your real test body.");
    }

    // =========================================================================
    // LoginAsync — JWT shape
    // =========================================================================

    [Fact(Skip = "TODO — implement this test")]
    public async Task LoginAsync_ValidCredentials_TokenContainsExpectedClaims()
    {
        // TODO: Arrange — prepare a user and valid LoginRequest.

        // TODO: Act — call LoginAsync.

        // TODO: Assert
        //   Decode result.Token using JwtSecurityTokenHandler and verify:
        //     - Sub claim == user.UserId.ToString()
        //     - Role claim == user.Role
        //     - UniqueName claim == user.Username
        throw new NotImplementedException("Replace this with your real test body.");
    }
}
