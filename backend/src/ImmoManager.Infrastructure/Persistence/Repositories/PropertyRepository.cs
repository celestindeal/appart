using Microsoft.EntityFrameworkCore;
using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;
using ImmoManager.Domain.Repositories;

namespace ImmoManager.Infrastructure.Persistence.Repositories;

public class PropertyRepository : Repository<Property>, IPropertyRepository
{
    public PropertyRepository(ImmoManagerDbContext context) : base(context) { }

    public async Task<IReadOnlyList<Property>> GetByUserIdAsync(Guid userId)
        => await _dbSet.Where(p => p.UserId == userId).ToListAsync();

    public async Task<IReadOnlyList<Property>> SearchAsync(string query, PropertyType? type, string? city)
    {
        var q = _dbSet.AsQueryable();
        if (!string.IsNullOrWhiteSpace(query))
            q = q.Where(p => p.Name.Contains(query) || p.City.Contains(query) || p.Address.Contains(query));
        if (type.HasValue)
            q = q.Where(p => p.PropertyType == type.Value);
        if (!string.IsNullOrWhiteSpace(city))
            q = q.Where(p => p.City == city);
        return await q.ToListAsync();
    }
}
