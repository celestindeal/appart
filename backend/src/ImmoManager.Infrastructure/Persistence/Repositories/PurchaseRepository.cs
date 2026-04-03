using Microsoft.EntityFrameworkCore;
using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;
using ImmoManager.Domain.Repositories;

namespace ImmoManager.Infrastructure.Persistence.Repositories;

public class PurchaseRepository : Repository<PurchaseProject>, IPurchaseRepository
{
    public PurchaseRepository(ImmoManagerDbContext context) : base(context) { }

    public async Task<IReadOnlyList<PurchaseProject>> GetByStatusAsync(PurchaseStatus status)
        => await _dbSet.Where(p => p.Status == status).ToListAsync();

    public async Task<PurchaseProject?> GetWithMilestonesAsync(Guid projectId)
        => await _dbSet.Include(p => p.PurchaseMilestones).FirstOrDefaultAsync(p => p.Id == projectId);
}
