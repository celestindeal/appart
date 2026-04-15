using ImmoManager.Application.DTOs.Tenants;

namespace ImmoManager.Application.Services.Interfaces;

public interface IPaymentService
{
    Task<List<RentPaymentDto>> GetByTenantAsync(Guid tenantId, Guid userId);
    Task<RentPaymentDto?> GetByIdAsync(Guid id, Guid userId);
    Task<RentPaymentDto> CreateAsync(CreatePaymentRequest request, Guid userId);
    Task<RentPaymentDto?> UpdateAsync(Guid id, UpdatePaymentRequest request, Guid userId);
    Task<bool> DeleteAsync(Guid id, Guid userId);
}
