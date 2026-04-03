using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Renovation;

public class RenovationTaskDto
{
    public Guid Id { get; set; }
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
    public Domain.Enums.TaskStatus Status { get; set; }
    public string? Contractor { get; set; }
    public int Progress { get; set; }
    public int Priority { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
