using ImmoManager.Application.DTOs.Renovation;

namespace ImmoManager.Application.Services.Interfaces;

public interface IRenovationService
{
    Task<List<RenovationProjectDto>> GetAllAsync();
    Task<RenovationProjectDto?> GetByIdAsync(Guid id);
    Task<RenovationProjectDto> CreateAsync(CreateRenovationRequest request);
    Task<RenovationProjectDto> UpdateAsync(Guid id, CreateRenovationRequest request);
    Task DeleteAsync(Guid id);
    Task<RenovationTaskDto> AddTaskAsync(Guid projectId, RenovationTaskDto task);
    Task<RenovationTaskDto> UpdateTaskAsync(Guid projectId, Guid taskId, RenovationTaskDto task);
    Task<BudgetItemDto> AddBudgetItemAsync(Guid projectId, BudgetItemDto item);
}
