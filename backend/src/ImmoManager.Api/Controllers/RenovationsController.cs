using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class RenovationsController : ControllerBase
{
    private readonly IRenovationService _renovationService;

    public RenovationsController(IRenovationService renovationService)
    {
        _renovationService = renovationService;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    // ── Renovation Projects CRUD ────────────────────────────────────────────────

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<RenovationProjectDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<RenovationProjectDto>>> GetAll()
    {
        var projects = await _renovationService.GetAllAsync(GetUserId());
        return Ok(projects);
    }

    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(RenovationProjectDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<RenovationProjectDto>> GetById(Guid id)
    {
        var project = await _renovationService.GetByIdAsync(id, GetUserId());
        if (project is null)
            return NotFound();

        return Ok(project);
    }

    [HttpPost]
    [ProducesResponseType(typeof(RenovationProjectDto), StatusCodes.Status201Created)]
    public async Task<ActionResult<RenovationProjectDto>> Create([FromBody] CreateRenovationProjectRequest request)
    {
        var project = await _renovationService.CreateAsync(request, GetUserId());
        return CreatedAtAction(nameof(GetById), new { id = project.Id }, project);
    }

    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(RenovationProjectDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<RenovationProjectDto>> Update(Guid id, [FromBody] UpdateRenovationProjectRequest request)
    {
        var project = await _renovationService.UpdateAsync(id, request, GetUserId());
        if (project is null)
            return NotFound();

        return Ok(project);
    }

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _renovationService.DeleteAsync(id, GetUserId());
        if (!deleted)
            return NotFound();

        return NoContent();
    }

    // ── Tasks ───────────────────────────────────────────────────────────────────

    [HttpGet("{id:guid}/tasks")]
    [ProducesResponseType(typeof(IEnumerable<RenovationTaskDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<RenovationTaskDto>>> GetTasks(Guid id)
    {
        var tasks = await _renovationService.GetTasksAsync(id, GetUserId());
        return Ok(tasks);
    }

    [HttpPost("{id:guid}/tasks")]
    [ProducesResponseType(typeof(RenovationTaskDto), StatusCodes.Status201Created)]
    public async Task<ActionResult<RenovationTaskDto>> AddTask(Guid id, [FromBody] CreateRenovationTaskRequest request)
    {
        var task = await _renovationService.AddTaskAsync(id, request, GetUserId());
        return CreatedAtAction(nameof(GetTasks), new { id }, task);
    }

    [HttpPut("{id:guid}/tasks/{taskId:guid}")]
    [ProducesResponseType(typeof(RenovationTaskDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<RenovationTaskDto>> UpdateTask(Guid id, Guid taskId, [FromBody] UpdateRenovationTaskRequest request)
    {
        var task = await _renovationService.UpdateTaskAsync(id, taskId, request, GetUserId());
        if (task is null)
            return NotFound();

        return Ok(task);
    }

    // ── Budget Items ────────────────────────────────────────────────────────────

    [HttpGet("{id:guid}/budget-items")]
    [ProducesResponseType(typeof(IEnumerable<BudgetItemDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<BudgetItemDto>>> GetBudgetItems(Guid id)
    {
        var items = await _renovationService.GetBudgetItemsAsync(id, GetUserId());
        return Ok(items);
    }

    [HttpPost("{id:guid}/budget-items")]
    [ProducesResponseType(typeof(BudgetItemDto), StatusCodes.Status201Created)]
    public async Task<ActionResult<BudgetItemDto>> AddBudgetItem(Guid id, [FromBody] CreateBudgetItemRequest request)
    {
        var item = await _renovationService.AddBudgetItemAsync(id, request, GetUserId());
        return CreatedAtAction(nameof(GetBudgetItems), new { id }, item);
    }
}

// ── DTOs ────────────────────────────────────────────────────────────────────────

public record RenovationProjectDto(
    Guid Id,
    Guid PropertyId,
    string ProjectName,
    string? Description,
    RenovationStatus Status,
    DateTime? StartDate,
    DateTime? ExpectedEndDate,
    DateTime? ActualEndDate,
    decimal TotalBudget,
    decimal TotalSpent,
    int Progress,
    IEnumerable<RenovationTaskDto>? Tasks,
    IEnumerable<BudgetItemDto>? BudgetItems,
    DateTime CreatedAt,
    DateTime UpdatedAt
);

public record CreateRenovationProjectRequest(
    Guid PropertyId,
    string ProjectName,
    string? Description,
    RenovationStatus Status,
    DateTime? StartDate,
    DateTime? ExpectedEndDate,
    decimal TotalBudget
);

public record UpdateRenovationProjectRequest(
    string ProjectName,
    string? Description,
    RenovationStatus Status,
    DateTime? StartDate,
    DateTime? ExpectedEndDate,
    DateTime? ActualEndDate,
    decimal TotalBudget,
    decimal TotalSpent,
    int Progress
);

public record RenovationTaskDto(
    Guid Id,
    Guid ProjectId,
    string TaskName,
    string? Description,
    WorkType WorkType,
    DateTime? PlannedStartDate,
    DateTime? PlannedEndDate,
    DateTime? ActualStartDate,
    DateTime? ActualEndDate,
    decimal BudgetAmount,
    decimal ActualCost,
    Domain.Enums.TaskStatus Status,
    string? Contractor,
    int Progress,
    int Priority,
    DateTime CreatedAt
);

public record CreateRenovationTaskRequest(
    string TaskName,
    string? Description,
    WorkType WorkType,
    DateTime? PlannedStartDate,
    DateTime? PlannedEndDate,
    decimal BudgetAmount,
    string? Contractor,
    int Priority
);

public record UpdateRenovationTaskRequest(
    string TaskName,
    string? Description,
    WorkType WorkType,
    DateTime? PlannedStartDate,
    DateTime? PlannedEndDate,
    DateTime? ActualStartDate,
    DateTime? ActualEndDate,
    decimal BudgetAmount,
    decimal ActualCost,
    Domain.Enums.TaskStatus Status,
    string? Contractor,
    int Progress,
    int Priority
);

public record BudgetItemDto(
    Guid Id,
    Guid RenovationProjectId,
    string ItemName,
    string? Category,
    decimal PlannedAmount,
    decimal SpentAmount,
    string? Supplier,
    int? Quantity,
    decimal? UnitPrice,
    string? Notes,
    DateTime CreatedAt
);

public record CreateBudgetItemRequest(
    string ItemName,
    string? Category,
    decimal PlannedAmount,
    string? Supplier,
    int? Quantity,
    decimal? UnitPrice,
    string? Notes
);

// ── Service interface ───────────────────────────────────────────────────────────

public interface IRenovationService
{
    Task<IEnumerable<RenovationProjectDto>> GetAllAsync(Guid userId);
    Task<RenovationProjectDto?> GetByIdAsync(Guid id, Guid userId);
    Task<RenovationProjectDto> CreateAsync(CreateRenovationProjectRequest request, Guid userId);
    Task<RenovationProjectDto?> UpdateAsync(Guid id, UpdateRenovationProjectRequest request, Guid userId);
    Task<bool> DeleteAsync(Guid id, Guid userId);
    Task<IEnumerable<RenovationTaskDto>> GetTasksAsync(Guid projectId, Guid userId);
    Task<RenovationTaskDto> AddTaskAsync(Guid projectId, CreateRenovationTaskRequest request, Guid userId);
    Task<RenovationTaskDto?> UpdateTaskAsync(Guid projectId, Guid taskId, UpdateRenovationTaskRequest request, Guid userId);
    Task<IEnumerable<BudgetItemDto>> GetBudgetItemsAsync(Guid projectId, Guid userId);
    Task<BudgetItemDto> AddBudgetItemAsync(Guid projectId, CreateBudgetItemRequest request, Guid userId);
}
