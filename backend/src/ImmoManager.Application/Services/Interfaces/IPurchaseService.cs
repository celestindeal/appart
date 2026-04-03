using ImmoManager.Application.DTOs.Purchase;

namespace ImmoManager.Application.Services.Interfaces;

public interface IPurchaseService
{
    Task<List<PurchaseProjectDto>> GetAllAsync();
    Task<PurchaseProjectDto?> GetByIdAsync(Guid id);
    Task<PurchaseProjectDto> CreateAsync(CreatePurchaseRequest request);
    Task<PurchaseProjectDto> UpdateAsync(Guid id, CreatePurchaseRequest request);
    Task DeleteAsync(Guid id);
    Task<MilestoneDto> AddMilestoneAsync(Guid projectId, MilestoneDto milestone);
    Task<MilestoneDto> UpdateMilestoneAsync(Guid projectId, Guid milestoneId, MilestoneDto milestone);
}
