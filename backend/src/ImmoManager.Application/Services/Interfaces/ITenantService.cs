using ImmoManager.Application.DTOs.Tenants;

namespace ImmoManager.Application.Services.Interfaces;

public interface ITenantService
{
    Task<List<TenantDto>> GetAllAsync(Guid userId);
    Task<TenantDto?> GetByIdAsync(Guid id, Guid userId);
    Task<TenantDto> CreateAsync(CreateTenantRequest request, Guid userId);
    Task<TenantDto?> UpdateAsync(Guid id, UpdateTenantRequest request, Guid userId);
    Task<bool> DeleteAsync(Guid id, Guid userId);
}
