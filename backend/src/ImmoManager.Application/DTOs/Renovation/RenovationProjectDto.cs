using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Renovation;

public class RenovationProjectDto
{
    public Guid Id { get; set; }
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
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public List<RenovationTaskDto> Tasks { get; set; } = new();
    public List<BudgetItemDto> BudgetItems { get; set; } = new();
}
