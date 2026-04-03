using ImmoManager.Domain.Common;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Entities;

public class RentPayment : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid PropertyId { get; set; }
    public decimal Amount { get; set; }
    public DateTime PaymentDueDate { get; set; }
    public DateTime? PaymentDate { get; set; }
    public PaymentMethod? PaymentMethod { get; set; }
    public PaymentStatus Status { get; set; }
    public string? Notes { get; set; }

    // Navigation properties
    public Tenant Tenant { get; set; } = null!;
    public Property Property { get; set; } = null!;
}
