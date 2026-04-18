using ImmoManager.Application.DTOs.Reminders;

namespace ImmoManager.Application.Services.Interfaces;

public interface IReminderService
{
    Task<List<ReminderDto>> GetByTenantAsync(Guid tenantId, Guid userId);
    Task<ReminderDto?> GetByIdAsync(Guid id, Guid userId);
    Task<ReminderDto> CreateAsync(CreateReminderRequest request, Guid userId);
    Task<ReminderDto?> UpdateAsync(Guid id, UpdateReminderRequest request, Guid userId);
    Task<bool> DeleteAsync(Guid id, Guid userId);
}
