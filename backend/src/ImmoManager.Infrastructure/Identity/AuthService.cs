using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using ImmoManager.Application.DTOs.Auth;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Entities;
using ImmoManager.Infrastructure.Persistence;

namespace ImmoManager.Infrastructure.Identity;

/// Implémentation du service d'authentification.
/// Gère le login, register, refresh token et logout avec JWT + BCrypt.
public class AuthService : IAuthService
{
    private readonly ImmoManagerDbContext _context;
    private readonly JwtSettings _jwtSettings;

    public AuthService(ImmoManagerDbContext context, IOptions<JwtSettings> jwtSettings)
    {
        _context = context;
        _jwtSettings = jwtSettings.Value;
    }

    /// Vérifie l'email et le mot de passe, met à jour la date de dernière connexion,
    /// puis génère un JWT + refresh token.
    public async Task<AuthResponse> LoginAsync(LoginRequest request)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email)
            ?? throw new UnauthorizedAccessException("Email ou mot de passe incorrect.");

        if (!BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
            throw new UnauthorizedAccessException("Email ou mot de passe incorrect.");

        user.LastLoginAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();

        return await GenerateAuthResponse(user);
    }

    /// Vérifie que l'email n'est pas déjà pris, hash le mot de passe avec BCrypt,
    /// crée l'utilisateur en base puis génère les tokens.
    public async Task<AuthResponse> RegisterAsync(RegisterRequest request)
    {
        if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            throw new InvalidOperationException("Cet email est déjà utilisé.");

        var user = new User
        {
            Email = request.Email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
            FirstName = request.FirstName,
            LastName = request.LastName,
            PhoneNumber = request.PhoneNumber,
            IsActive = true,
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return await GenerateAuthResponse(user);
    }

    /// Cherche le refresh token en base (non révoqué, non expiré),
    /// le révoque puis génère une nouvelle paire de tokens.
    public async Task<AuthResponse> RefreshTokenAsync(RefreshTokenRequest request)
    {
        var storedToken = await _context.RefreshTokens
            .Include(r => r.User)
            .FirstOrDefaultAsync(r => r.Token == request.RefreshToken && !r.IsRevoked && r.ExpiryDate > DateTime.UtcNow)
            ?? throw new UnauthorizedAccessException("Token invalide ou expiré.");

        storedToken.IsRevoked = true;
        await _context.SaveChangesAsync();

        return await GenerateAuthResponse(storedToken.User);
    }

    /// Révoque un refresh token spécifique (si il existe et n'est pas déjà révoqué).
    public async Task RevokeTokenAsync(string refreshToken)
    {
        var storedToken = await _context.RefreshTokens
            .FirstOrDefaultAsync(r => r.Token == refreshToken && !r.IsRevoked);

        if (storedToken != null)
        {
            storedToken.IsRevoked = true;
            await _context.SaveChangesAsync();
        }
    }

    /// Révoque tous les refresh tokens actifs d'un utilisateur (déconnexion complète).
    public async Task LogoutAsync(string userId)
    {
        var tokens = await _context.RefreshTokens
            .Where(r => r.UserId == Guid.Parse(userId) && !r.IsRevoked)
            .ToListAsync();

        foreach (var token in tokens)
            token.IsRevoked = true;

        await _context.SaveChangesAsync();
    }

    /// Récupère le profil utilisateur par ID. Renvoie null si l'utilisateur n'existe pas ou est inactif.
    public async Task<UserDto?> GetCurrentUserAsync(Guid userId)
    {
        var user = await _context.Users.FindAsync(userId);
        if (user == null || !user.IsActive) return null;

        return new UserDto
        {
            Id = user.Id,
            Email = user.Email,
            FirstName = user.FirstName,
            LastName = user.LastName,
            PhoneNumber = user.PhoneNumber,
            ProfileImageUrl = user.ProfileImageUrl,
        };
    }

    /// Génère la réponse d'auth complète : crée un JWT, un refresh token,
    /// sauvegarde le refresh token en base et renvoie le tout avec les infos user.
    private async Task<AuthResponse> GenerateAuthResponse(User user)
    {
        var accessToken = GenerateJwtToken(user);
        var refreshToken = GenerateRefreshToken();

        _context.RefreshTokens.Add(new RefreshToken
        {
            UserId = user.Id,
            Token = refreshToken,
            ExpiryDate = DateTime.UtcNow.AddDays(_jwtSettings.RefreshTokenExpirationDays),
        });
        await _context.SaveChangesAsync();

        return new AuthResponse
        {
            AccessToken = accessToken,
            RefreshToken = refreshToken,
            ExpiresIn = _jwtSettings.ExpirationMinutes * 60,
            User = new UserDto
            {
                Id = user.Id,
                Email = user.Email,
                FirstName = user.FirstName,
                LastName = user.LastName,
                PhoneNumber = user.PhoneNumber,
                ProfileImageUrl = user.ProfileImageUrl,
            },
        };
    }

    /// Crée un JWT signé avec les claims de l'utilisateur (id, email, prénom, nom).
    /// La durée de validité est définie dans JwtSettings.ExpirationMinutes (24h = 1440 min).
    private string GenerateJwtToken(User user)
    {
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.Secret));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(ClaimTypes.Email, user.Email),
            new Claim(ClaimTypes.GivenName, user.FirstName),
            new Claim(ClaimTypes.Surname, user.LastName),
        };

        var token = new JwtSecurityToken(
            issuer: _jwtSettings.Issuer,
            audience: _jwtSettings.Audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(_jwtSettings.ExpirationMinutes),
            signingCredentials: credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    /// Génère un refresh token aléatoire de 64 octets encodé en Base64.
    private static string GenerateRefreshToken()
    {
        var randomBytes = new byte[64];
        using var rng = RandomNumberGenerator.Create();
        rng.GetBytes(randomBytes);
        return Convert.ToBase64String(randomBytes);
    }
}
