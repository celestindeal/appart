using ImmoManager.Domain.Common;

namespace ImmoManager.Domain.Entities;

public class BudgetItem : BaseEntity
{
    public Guid RenovationProjectId { get; set; }
    public string ItemName { get; set; } = string.Empty;
    public string? Category { get; set; }
    public decimal PlannedAmount { get; set; }
    public decimal SpentAmount { get; set; }
    public string? Supplier { get; set; }
    public int? Quantity { get; set; }
    public decimal? UnitPrice { get; set; }
    public string? Notes { get; set; }

    // Navigation properties
    public RenovationProject RenovationProject { get; set; } = null!;
}
