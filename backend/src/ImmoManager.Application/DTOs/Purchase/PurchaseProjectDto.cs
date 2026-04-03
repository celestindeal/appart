using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Purchase;

public class PurchaseProjectDto
{
    public Guid Id { get; set; }
    public Guid PropertyId { get; set; }
    public PurchaseStatus Status { get; set; }
    public decimal TargetPrice { get; set; }
    public decimal? FinalPrice { get; set; }
    public decimal? DownPayment { get; set; }
    public decimal? LoanAmount { get; set; }
    public decimal? InterestRate { get; set; }
    public int? LoanTermMonths { get; set; }
    public decimal? NotaryFees { get; set; }
    public decimal? AgencyFees { get; set; }
    public decimal? OtherCosts { get; set; }
    public DateTime? ExpectedCompletionDate { get; set; }
    public DateTime? ActualCompletionDate { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public List<MilestoneDto> Milestones { get; set; } = new();
}
