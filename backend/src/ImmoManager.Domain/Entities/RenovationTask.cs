using ImmoManager.Domain.Common;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Entities;

public class RenovationTask : BaseEntity
{
    public Guid ProjectId { get; set; }
    public string TaskName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public WorkType WorkType { get; set; }
    public DateTime? PlannedStartDate { get; set; }
    public DateTime? PlannedEndDate { get; set; }
    public DateTime? ActualStartDate { get; set; }
    public DateTime? ActualEndDate { get; set; }
    public decimal BudgetAmount { get; set; }
    public decimal ActualCost { get; set; }
    public Enums.TaskStatus Status { get; set; }
    public string? Contractor { get; set; }
    public int Progress { get; set; }
    public int Priority { get; set; }

    // Navigation properties
    public RenovationProject RenovationProject { get; set; } = null!;
}
