using ImmoManager.Domain.Common;

namespace ImmoManager.Domain.Entities;

public class PropertyExpense : BaseEntity
{
    public Guid PropertyId { get; set; }
    public string ExpenseType { get; set; } = string.Empty;
    public decimal Amount { get; set; }
    public DateTime ExpenseDate { get; set; }
    public DateTime? PaymentDate { get; set; }
    public string? Description { get; set; }
    public string? ReceiptUrl { get; set; }
    public string? Status { get; set; }

    // Navigation properties
    public Property Property { get; set; } = null!;
}
