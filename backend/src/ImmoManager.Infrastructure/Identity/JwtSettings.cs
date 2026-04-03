namespace ImmoManager.Infrastructure.Identity;

/// Configuration JWT chargée depuis appsettings.json (section "JwtSettings").
public class JwtSettings
{
    /// Clé secrète pour signer les tokens (min 32 caractères).
    public string Secret { get; set; } = string.Empty;

    /// Émetteur du token (vérifié à chaque requête).
    public string Issuer { get; set; } = string.Empty;

    /// Audience du token (vérifié à chaque requête).
    public string Audience { get; set; } = string.Empty;

    /// Durée de validité du JWT en minutes (1440 = 24h).
    public int ExpirationMinutes { get; set; } = 1440;

    /// Durée de validité du refresh token en jours.
    public int RefreshTokenExpirationDays { get; set; } = 7;
}
