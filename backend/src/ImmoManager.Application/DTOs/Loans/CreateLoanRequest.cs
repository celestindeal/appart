using System.ComponentModel.DataAnnotations;

namespace ImmoManager.Application.DTOs.Loans;

public class CreateLoanRequest
{
    [Required]
    public Guid PropertyId { get; set; }

    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;

    [MaxLength(200)]
    public string? BankName { get; set; }

    [Required]
    [Range(0, (double)decimal.MaxValue)]
    public decimal Amount { get; set; }

    [Required]
    [Range(0, 100)]
    public decimal InterestRate { get; set; }

    [Required]
    [Range(1, 600)]
    public int DurationMonths { get; set; }

    [Required]
    public DateTime StartDate { get; set; }

    [Range(0, 600)]
    public int DeferralMonths { get; set; }

    [MaxLength(20)]
    public string? DeferralType { get; set; }

    [Required]
    [Range(0, (double)decimal.MaxValue)]
    public decimal MonthlyPayment { get; set; }
}
