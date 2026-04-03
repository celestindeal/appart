using ImmoManager.Domain.Entities;

namespace ImmoManager.Domain.Repositories;

public interface IAccountingRepository : IRepository<AccountingEntry>
{
    Task<IReadOnlyList<AccountingEntry>> GetByDateRangeAsync(DateTime startDate, DateTime endDate);
    Task<IReadOnlyList<AccountingEntry>> GetByPropertyIdAsync(Guid propertyId);
    Task<decimal> GetSummaryAsync(Guid userId, DateTime? startDate, DateTime? endDate);
}
