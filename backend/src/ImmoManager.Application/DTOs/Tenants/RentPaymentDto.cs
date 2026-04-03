using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Tenants;

public class RentPaymentDto
{
    public Guid Id { get; set; }
    public Guid TenantId { get; set; }
    public Guid PropertyId { get; set; }
    public decimal Amount { get; set; }
    public DateTime PaymentDueDate { get; set; }
    public DateTime? PaymentDate { get; set; }
    public PaymentMethod? PaymentMethod { get; set; }
    public PaymentStatus Status { get; set; }
    public string? Notes { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
