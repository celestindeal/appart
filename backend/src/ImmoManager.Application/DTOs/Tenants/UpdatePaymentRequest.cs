using System.ComponentModel.DataAnnotations;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Tenants;

public class UpdatePaymentRequest
{
    [Required]
    [Range(0, double.MaxValue)]
    public decimal Amount { get; set; }

    [Required]
    public DateTime PaymentDueDate { get; set; }

    public DateTime? PaymentDate { get; set; }
    public PaymentMethod? PaymentMethod { get; set; }
    public PaymentStatus Status { get; set; } = PaymentStatus.Pending;
    public string? Notes { get; set; }
}
