using ImmoManager.Domain.Common;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Entities;

public class PurchaseProject : BaseEntity
{
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

    // Navigation properties
    public Property Property { get; set; } = null!;
    public ICollection<PurchaseMilestone> PurchaseMilestones { get; set; } = new List<PurchaseMilestone>();
}
