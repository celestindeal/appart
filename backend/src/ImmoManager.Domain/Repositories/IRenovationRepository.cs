using ImmoManager.Domain.Entities;

namespace ImmoManager.Domain.Repositories;

public interface IRenovationRepository : IRepository<RenovationProject>
{
    Task<IReadOnlyList<RenovationProject>> GetByPropertyIdAsync(Guid propertyId);
    Task<RenovationProject?> GetWithTasksAsync(Guid projectId);
}
