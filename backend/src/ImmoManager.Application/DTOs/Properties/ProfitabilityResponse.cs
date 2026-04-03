namespace ImmoManager.Application.DTOs.Properties;

public class ProfitabilityResponse
{
    public decimal GrossYield { get; set; }
    public decimal NetYield { get; set; }
    public decimal MonthlyCashFlow { get; set; }
    public decimal MonthlyMortgage { get; set; }
    public decimal TotalInvestment { get; set; }
    public decimal AnnualRent { get; set; }
    public decimal AnnualExpenses { get; set; }
    public decimal AnnualNetIncome { get; set; }
    public decimal CashOnCashReturn { get; set; }
    public decimal? PricePerSqm { get; set; }
    public decimal BreakEvenYears { get; set; }
}
