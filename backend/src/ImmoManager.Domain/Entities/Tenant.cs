using ImmoManager.Domain.Common;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Entities;

public class Tenant : BaseEntity
{
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

    // Navigation properties
    public Property Property { get; set; } = null!;
    public ICollection<TenantDocument> TenantDocuments { get; set; } = new List<TenantDocument>();
    public ICollection<RentPayment> RentPayments { get; set; } = new List<RentPayment>();
    public ICollection<Reminder> Reminders { get; set; } = new List<Reminder>();
}
