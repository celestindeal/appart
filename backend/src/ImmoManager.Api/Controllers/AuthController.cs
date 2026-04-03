using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Application.DTOs.Auth;
using ImmoManager.Application.Services.Interfaces;

namespace ImmoManager.Api.Controllers;

/// Contrôleur d'authentification.
/// Gère login, register, refresh token, logout et récupération du profil.
[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    /// Connecte un utilisateur avec email + mot de passe.
    /// Renvoie un JWT valide 24h + un refresh token.
    [HttpPost("login")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<AuthResponse>> Login([FromBody] LoginRequest request)
    {
        var response = await _authService.LoginAsync(request);
        return Ok(response);
    }

    /// Crée un nouveau compte. Le mot de passe est hashé avec BCrypt côté serveur.
    /// Renvoie directement un JWT (l'utilisateur est connecté après inscription).
    [HttpPost("register")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<AuthResponse>> Register([FromBody] RegisterRequest request)
    {
        var response = await _authService.RegisterAsync(request);
        return CreatedAtAction(nameof(GetCurrentUser), response);
    }

    /// Échange un refresh token valide contre un nouveau JWT + nouveau refresh token.
    /// L'ancien refresh token est automatiquement révoqué.
    [HttpPost("refresh")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<AuthResponse>> RefreshToken([FromBody] RefreshTokenRequest request)
    {
        var response = await _authService.RefreshTokenAsync(request);
        return Ok(response);
    }

    /// Déconnecte l'utilisateur en révoquant son refresh token.
    /// Nécessite d'être authentifié (JWT valide dans le header).
    [Authorize]
    [HttpPost("logout")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Logout([FromBody] RefreshTokenRequest request)
    {
        await _authService.RevokeTokenAsync(request.RefreshToken);
        return NoContent();
    }

    /// Récupère le profil de l'utilisateur connecté à partir du JWT.
    /// Extrait l'ID utilisateur des claims du token.
    [Authorize]
    [HttpGet("me")]
    [ProducesResponseType(typeof(UserDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<UserDto>> GetCurrentUser()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (userId is null)
            return Unauthorized();

        var user = await _authService.GetCurrentUserAsync(Guid.Parse(userId));
        if (user is null)
            return NotFound();

        return Ok(user);
    }
}
