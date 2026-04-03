using Microsoft.EntityFrameworkCore;
using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;
using ImmoManager.Domain.Repositories;

namespace ImmoManager.Infrastructure.Persistence.Repositories;

public class AccountingRepository : Repository<AccountingEntry>, IAccountingRepository
{
    public AccountingRepository(ImmoManagerDbContext context) : base(context) { }

    public async Task<IReadOnlyList<AccountingEntry>> GetByDateRangeAsync(DateTime startDate, DateTime endDate)
        => await _dbSet.Where(e => e.EntryDate >= startDate && e.EntryDate <= endDate).OrderByDescending(e => e.EntryDate).ToListAsync();

    public async Task<IReadOnlyList<AccountingEntry>> GetByPropertyIdAsync(Guid propertyId)
        => await _dbSet.Where(e => e.PropertyId == propertyId).OrderByDescending(e => e.EntryDate).ToListAsync();

    public async Task<decimal> GetSummaryAsync(Guid userId, DateTime? startDate, DateTime? endDate)
    {
        var query = _dbSet.Where(e => e.UserId == userId);
        if (startDate.HasValue) query = query.Where(e => e.EntryDate >= startDate.Value);
        if (endDate.HasValue) query = query.Where(e => e.EntryDate <= endDate.Value);
        var entries = await query.ToListAsync();
        var income = entries.Where(e => e.EntryType == EntryType.Income).Sum(e => e.Amount);
        var expenses = entries.Where(e => e.EntryType == EntryType.Expense).Sum(e => e.Amount);
        return income - expenses;
    }
}
