using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Repositories;

public interface IPropertyRepository : IRepository<Property>
{
    Task<IReadOnlyList<Property>> GetByUserIdAsync(Guid userId);
    Task<IReadOnlyList<Property>> SearchAsync(string query, PropertyType? type, string? city);
}
