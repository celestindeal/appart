using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Repositories;

public interface IPurchaseRepository : IRepository<PurchaseProject>
{
    Task<IReadOnlyList<PurchaseProject>> GetByStatusAsync(PurchaseStatus status);
    Task<PurchaseProject?> GetWithMilestonesAsync(Guid projectId);
}
