using ImmoManager.Domain.Entities;

namespace ImmoManager.Domain.Repositories;

public interface ITenantRepository : IRepository<Tenant>
{
    Task<IReadOnlyList<Tenant>> GetByPropertyIdAsync(Guid propertyId);
    Task<IReadOnlyList<Tenant>> GetActiveTenantsAsync();
}
