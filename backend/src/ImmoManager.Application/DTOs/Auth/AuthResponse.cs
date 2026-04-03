namespace ImmoManager.Application.DTOs.Auth;

/// Réponse renvoyée après un login, register ou refresh réussi.
/// Contient le JWT, le refresh token et les infos utilisateur.
public class AuthResponse
{
    /// Token JWT pour authentifier les requêtes (valide 24h).
    public string AccessToken { get; set; } = string.Empty;

    /// Token de rafraîchissement pour obtenir un nouveau JWT sans se reconnecter.
    public string RefreshToken { get; set; } = string.Empty;

    /// Durée de validité du JWT en secondes.
    public int ExpiresIn { get; set; }

    /// Informations de l'utilisateur connecté.
    public UserDto User { get; set; } = null!;
}

/// Représentation simplifiée d'un utilisateur pour les réponses API.
public class UserDto
{
    public Guid Id { get; set; }
    public string Email { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? PhoneNumber { get; set; }
    public string? ProfileImageUrl { get; set; }
}
