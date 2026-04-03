using System.ComponentModel.DataAnnotations;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Business;

public class CreateContactRequest
{
    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;

    [EmailAddress]
    public string? Email { get; set; }

    [Phone]
    public string? PhoneNumber { get; set; }

    [Required]
    public ContactType ContactType { get; set; }

    [MaxLength(200)]
    public string? CompanyName { get; set; }

    [MaxLength(500)]
    public string? Address { get; set; }

    [MaxLength(1000)]
    public string? Notes { get; set; }
}
