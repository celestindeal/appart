using ImmoManager.Application.DTOs.Auth;

namespace ImmoManager.Application.Services.Interfaces;

/// Contrat du service d'authentification.
/// Définit toutes les opérations liées à la connexion, inscription et gestion des tokens.
public interface IAuthService
{
    /// Connecte un utilisateur avec email + mot de passe. Renvoie JWT + refresh token.
    Task<AuthResponse> LoginAsync(LoginRequest request);

    /// Crée un nouveau compte utilisateur. Le mot de passe est hashé avec BCrypt.
    Task<AuthResponse> RegisterAsync(RegisterRequest request);

    /// Génère un nouveau JWT à partir d'un refresh token valide. L'ancien refresh token est révoqué.
    Task<AuthResponse> RefreshTokenAsync(RefreshTokenRequest request);

    /// Révoque un refresh token spécifique (utilisé lors du logout).
    Task RevokeTokenAsync(string refreshToken);

    /// Révoque tous les refresh tokens d'un utilisateur (déconnexion complète).
    Task LogoutAsync(string userId);

    /// Récupère le profil d'un utilisateur par son ID. Renvoie null si inactif ou inexistant.
    Task<UserDto?> GetCurrentUserAsync(Guid userId);
}
