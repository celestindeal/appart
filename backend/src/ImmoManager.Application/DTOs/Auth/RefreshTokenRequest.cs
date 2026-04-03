using System.ComponentModel.DataAnnotations;

namespace ImmoManager.Application.DTOs.Auth;

/// Données envoyées par le client pour rafraîchir son token JWT.
public class RefreshTokenRequest
{
    [Required]
    public string RefreshToken { get; set; } = string.Empty;
}
