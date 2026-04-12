namespace ImmoManager.Application.DTOs.Loans;

public class LoanDto
{
    public Guid Id { get; set; }
    public Guid PropertyId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? BankName { get; set; }
    public decimal Amount { get; set; }
    public decimal InterestRate { get; set; }
    public int DurationMonths { get; set; }
    public DateTime StartDate { get; set; }
    public int DeferralMonths { get; set; }
    public string? DeferralType { get; set; }
    public decimal MonthlyPayment { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
