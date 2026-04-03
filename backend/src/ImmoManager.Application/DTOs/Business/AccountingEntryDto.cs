using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Business;

public class AccountingEntryDto
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public Guid? PropertyId { get; set; }
    public EntryType EntryType { get; set; }
    public decimal Amount { get; set; }
    public DateTime EntryDate { get; set; }
    public string? Description { get; set; }
    public ExpenseCategory Category { get; set; }
    public string? Notes { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
