using System.ComponentModel.DataAnnotations;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Tenants;

public class CreateTenantRequest
{
    [Required]
    public Guid PropertyId { get; set; }

    [Required]
    [MaxLength(100)]
    public string FirstName { get; set; } = string.Empty;

    [Required]
    [MaxLength(100)]
    public string LastName { get; set; } = string.Empty;

    [EmailAddress]
    public string? Email { get; set; }

    [Phone]
    public string? PhoneNumber { get; set; }

    public string? IdentityDocumentType { get; set; }
    public string? IdentityDocumentNumber { get; set; }

    [Required]
    public DateTime MoveInDate { get; set; }

    public DateTime? MoveOutDate { get; set; }

    [Required]
    [Range(0, double.MaxValue)]
    public decimal MonthlyRent { get; set; }

    [Range(0, double.MaxValue)]
    public decimal? DepositAmount { get; set; }

    public TenantStatus Status { get; set; } = TenantStatus.Active;
}
