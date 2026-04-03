namespace ImmoManager.Application.DTOs.Business;

public class FinancialSummaryDto
{
    public decimal TotalIncome { get; set; }
    public decimal TotalExpenses { get; set; }
    public decimal NetResult { get; set; }
    public int PropertyCount { get; set; }
    public int TenantCount { get; set; }
    public decimal OccupancyRate { get; set; }
}
