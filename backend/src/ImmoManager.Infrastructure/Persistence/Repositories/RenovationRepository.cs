using Microsoft.EntityFrameworkCore;
using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Repositories;

namespace ImmoManager.Infrastructure.Persistence.Repositories;

public class RenovationRepository : Repository<RenovationProject>, IRenovationRepository
{
    public RenovationRepository(ImmoManagerDbContext context) : base(context) { }

    public async Task<IReadOnlyList<RenovationProject>> GetByPropertyIdAsync(Guid propertyId)
        => await _dbSet.Where(r => r.PropertyId == propertyId).ToListAsync();

    public async Task<RenovationProject?> GetWithTasksAsync(Guid projectId)
        => await _dbSet.Include(r => r.RenovationTasks).Include(r => r.BudgetItems).FirstOrDefaultAsync(r => r.Id == projectId);
}
