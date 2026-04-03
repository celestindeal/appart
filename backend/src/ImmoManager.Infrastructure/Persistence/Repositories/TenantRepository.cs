using Microsoft.EntityFrameworkCore;
using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;
using ImmoManager.Domain.Repositories;

namespace ImmoManager.Infrastructure.Persistence.Repositories;

public class TenantRepository : Repository<Tenant>, ITenantRepository
{
    public TenantRepository(ImmoManagerDbContext context) : base(context) { }

    public async Task<IReadOnlyList<Tenant>> GetByPropertyIdAsync(Guid propertyId)
        => await _dbSet.Where(t => t.PropertyId == propertyId).ToListAsync();

    public async Task<IReadOnlyList<Tenant>> GetActiveTenantsAsync()
        => await _dbSet.Where(t => t.Status == TenantStatus.Active).ToListAsync();
}
