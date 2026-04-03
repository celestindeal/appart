using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Tenants;

public class TenantDto
{
    public Guid Id { get; set; }
    public Guid PropertyId { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? PhoneNumber { get; set; }
    public string? IdentityDocumentType { get; set; }
    public string? IdentityDocumentNumber { get; set; }
    public DateTime MoveInDate { get; set; }
    public DateTime? MoveOutDate { get; set; }
    public decimal MonthlyRent { get; set; }
    public decimal? DepositAmount { get; set; }
    public DateTime? DepositReturnedDate { get; set; }
    public TenantStatus Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
