namespace ImmoManager.Application.DTOs.Renovation;

public class BudgetItemDto
{
    public Guid Id { get; set; }
    public Guid RenovationProjectId { get; set; }
    public string ItemName { get; set; } = string.Empty;
    public string? Category { get; set; }
    public decimal PlannedAmount { get; set; }
    public decimal SpentAmount { get; set; }
    public string? Supplier { get; set; }
    public int? Quantity { get; set; }
    public decimal? UnitPrice { get; set; }
    public string? Notes { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
