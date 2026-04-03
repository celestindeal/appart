using ImmoManager.Application.DTOs.Tenants;

namespace ImmoManager.Application.Services.Interfaces;

public interface ITenantService
{
    Task<List<TenantDto>> GetAllAsync();
    Task<TenantDto?> GetByIdAsync(Guid id);
    Task<TenantDto> CreateAsync(CreateTenantRequest request);
    Task<TenantDto> UpdateAsync(Guid id, CreateTenantRequest request);
    Task DeleteAsync(Guid id);
    Task<List<RentPaymentDto>> GetPaymentsAsync(Guid tenantId);
    Task<RentPaymentDto> AddPaymentAsync(Guid tenantId, CreatePaymentRequest request);
}
