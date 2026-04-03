using ImmoManager.Domain.Common;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Entities;

public class PurchaseMilestone : BaseEntity
{
    public Guid ProjectId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public MilestoneType MilestoneType { get; set; }
    public DateTime? PlannedDate { get; set; }
    public DateTime? ActualDate { get; set; }
    public bool IsCompleted { get; set; }
    public string? Notes { get; set; }

    // Navigation properties
    public PurchaseProject PurchaseProject { get; set; } = null!;
}
