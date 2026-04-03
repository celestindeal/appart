using ImmoManager.Domain.Common;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Entities;

public class AccountingEntry : BaseEntity
{
    public Guid UserId { get; set; }
    public Guid? PropertyId { get; set; }
    public EntryType EntryType { get; set; }
    public decimal Amount { get; set; }
    public DateTime EntryDate { get; set; }
    public string? Description { get; set; }
    public ExpenseCategory Category { get; set; }
    public string? Notes { get; set; }

    // Navigation properties
    public User User { get; set; } = null!;
    public Property? Property { get; set; }
}
