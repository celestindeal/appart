using System.ComponentModel.DataAnnotations;

namespace ImmoManager.Application.DTOs.Auth;

/// Données envoyées par le client pour se connecter.
public class LoginRequest
{
    [Required]
    [EmailAddress]
    public string Email { get; set; } = string.Empty;

    [Required]
    [MinLength(6)]
    public string Password { get; set; } = string.Empty;
}
