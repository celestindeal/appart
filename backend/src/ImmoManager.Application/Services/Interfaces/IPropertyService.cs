using ImmoManager.Application.DTOs.Properties;

namespace ImmoManager.Application.Services.Interfaces;

public interface IPropertyService
{
    Task<List<PropertyDto>> GetAllAsync(string userId);
    Task<PropertyDto?> GetByIdAsync(Guid id);
    Task<PropertyDto> CreateAsync(string userId, CreatePropertyRequest request);
    Task<PropertyDto> UpdateAsync(Guid id, UpdatePropertyRequest request);
    Task DeleteAsync(Guid id);
    Task<List<PropertyDto>> SearchAsync(PropertySearchFilter filter);
    ProfitabilityResponse CalculateProfitability(ProfitabilityRequest request);
}
