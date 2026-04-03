using ImmoManager.Domain.Common;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Entities;

public class RenovationProject : BaseEntity
{
    public Guid PropertyId { get; set; }
    public string ProjectName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public RenovationStatus Status { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? ExpectedEndDate { get; set; }
    public DateTime? ActualEndDate { get; set; }
    public decimal TotalBudget { get; set; }
    public decimal TotalSpent { get; set; }
    public int Progress { get; set; }

    // Navigation properties
    public Property Property { get; set; } = null!;
    public ICollection<RenovationTask> RenovationTasks { get; set; } = new List<RenovationTask>();
    public ICollection<BudgetItem> BudgetItems { get; set; } = new List<BudgetItem>();
}
