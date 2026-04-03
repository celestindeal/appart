using System.ComponentModel.DataAnnotations;

namespace ImmoManager.Application.DTOs.Properties;

public class ProfitabilityRequest
{
    [Required]
    [Range(0, double.MaxValue)]
    public decimal PurchasePrice { get; set; }

    [Required]
    [Range(0, double.MaxValue)]
    public decimal MonthlyRent { get; set; }

    [Range(0, double.MaxValue)]
    public decimal MonthlyCharges { get; set; }

    [Range(0, double.MaxValue)]
    public decimal AnnualTax { get; set; }

    [Range(0, double.MaxValue)]
    public decimal AnnualInsurance { get; set; }

    [Range(0, 100)]
    public decimal LoanRate { get; set; }

    [Range(1, 50)]
    public int LoanDurationYears { get; set; }

    [Range(0, double.MaxValue)]
    public decimal DownPayment { get; set; }

    [Range(0, double.MaxValue)]
    public decimal RenovationCost { get; set; }

    [Range(0, 30)]
    public decimal NotaryFeesPercent { get; set; } = 7.5m;
}
