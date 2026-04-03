using System.ComponentModel.DataAnnotations;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Purchase;

public class CreatePurchaseRequest
{
    [Required]
    public Guid PropertyId { get; set; }

    public PurchaseStatus Status { get; set; } = PurchaseStatus.Prospect;

    [Required]
    [Range(0, double.MaxValue)]
    public decimal TargetPrice { get; set; }

    public decimal? FinalPrice { get; set; }
    public decimal? DownPayment { get; set; }
    public decimal? LoanAmount { get; set; }

    [Range(0, 100)]
    public decimal? InterestRate { get; set; }

    [Range(1, 600)]
    public int? LoanTermMonths { get; set; }

    public decimal? NotaryFees { get; set; }
    public decimal? AgencyFees { get; set; }
    public decimal? OtherCosts { get; set; }
    public DateTime? ExpectedCompletionDate { get; set; }
}
