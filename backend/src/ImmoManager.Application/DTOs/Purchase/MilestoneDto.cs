using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Purchase;

public class MilestoneDto
{
    public Guid Id { get; set; }
    public Guid ProjectId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public MilestoneType MilestoneType { get; set; }
    public DateTime? PlannedDate { get; set; }
    public DateTime? ActualDate { get; set; }
    public bool IsCompleted { get; set; }
    public string? Notes { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
