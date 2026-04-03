using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/purchases")]
public class PurchaseProjectsController : ControllerBase
{
    private readonly IPurchaseProjectService _purchaseService;

    public PurchaseProjectsController(IPurchaseProjectService purchaseService)
    {
        _purchaseService = purchaseService;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    // ── Purchase Projects CRUD ──────────────────────────────────────────────────

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<PurchaseProjectDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<PurchaseProjectDto>>> GetAll()
    {
        var projects = await _purchaseService.GetAllAsync(GetUserId());
        return Ok(projects);
    }

    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(PurchaseProjectDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<PurchaseProjectDto>> GetById(Guid id)
    {
        var project = await _purchaseService.GetByIdAsync(id, GetUserId());
        if (project is null)
            return NotFound();

        return Ok(project);
    }

    [HttpPost]
    [ProducesResponseType(typeof(PurchaseProjectDto), StatusCodes.Status201Created)]
    public async Task<ActionResult<PurchaseProjectDto>> Create([FromBody] CreatePurchaseProjectRequest request)
    {
        var project = await _purchaseService.CreateAsync(request, GetUserId());
        return CreatedAtAction(nameof(GetById), new { id = project.Id }, project);
    }

    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(PurchaseProjectDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<PurchaseProjectDto>> Update(Guid id, [FromBody] UpdatePurchaseProjectRequest request)
    {
        var project = await _purchaseService.UpdateAsync(id, request, GetUserId());
        if (project is null)
            return NotFound();

        return Ok(project);
    }

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _purchaseService.DeleteAsync(id, GetUserId());
        if (!deleted)
            return NotFound();

        return NoContent();
    }

    // ── Milestones ──────────────────────────────────────────────────────────────

    [HttpGet("{id:guid}/milestones")]
    [ProducesResponseType(typeof(IEnumerable<PurchaseMilestoneDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<PurchaseMilestoneDto>>> GetMilestones(Guid id)
    {
        var milestones = await _purchaseService.GetMilestonesAsync(id, GetUserId());
        return Ok(milestones);
    }

    [HttpPost("{id:guid}/milestones")]
    [ProducesResponseType(typeof(PurchaseMilestoneDto), StatusCodes.Status201Created)]
    public async Task<ActionResult<PurchaseMilestoneDto>> AddMilestone(Guid id, [FromBody] CreatePurchaseMilestoneRequest request)
    {
        var milestone = await _purchaseService.AddMilestoneAsync(id, request, GetUserId());
        return CreatedAtAction(nameof(GetMilestones), new { id }, milestone);
    }

    [HttpPut("{id:guid}/milestones/{milestoneId:guid}")]
    [ProducesResponseType(typeof(PurchaseMilestoneDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<PurchaseMilestoneDto>> UpdateMilestone(Guid id, Guid milestoneId, [FromBody] UpdatePurchaseMilestoneRequest request)
    {
        var milestone = await _purchaseService.UpdateMilestoneAsync(id, milestoneId, request, GetUserId());
        if (milestone is null)
            return NotFound();

        return Ok(milestone);
    }
}

// ── DTOs ────────────────────────────────────────────────────────────────────────

public record PurchaseProjectDto(
    Guid Id,
    Guid PropertyId,
    PurchaseStatus Status,
    decimal TargetPrice,
    decimal? FinalPrice,
    decimal? DownPayment,
    decimal? LoanAmount,
    decimal? InterestRate,
    int? LoanTermMonths,
    decimal? NotaryFees,
    decimal? AgencyFees,
    decimal? OtherCosts,
    DateTime? ExpectedCompletionDate,
    DateTime? ActualCompletionDate,
    IEnumerable<PurchaseMilestoneDto>? Milestones,
    DateTime CreatedAt,
    DateTime UpdatedAt
);

public record CreatePurchaseProjectRequest(
    Guid PropertyId,
    PurchaseStatus Status,
    decimal TargetPrice,
    decimal? FinalPrice,
    decimal? DownPayment,
    decimal? LoanAmount,
    decimal? InterestRate,
    int? LoanTermMonths,
    decimal? NotaryFees,
    decimal? AgencyFees,
    decimal? OtherCosts,
    DateTime? ExpectedCompletionDate
);

public record UpdatePurchaseProjectRequest(
    PurchaseStatus Status,
    decimal TargetPrice,
    decimal? FinalPrice,
    decimal? DownPayment,
    decimal? LoanAmount,
    decimal? InterestRate,
    int? LoanTermMonths,
    decimal? NotaryFees,
    decimal? AgencyFees,
    decimal? OtherCosts,
    DateTime? ExpectedCompletionDate,
    DateTime? ActualCompletionDate
);

public record PurchaseMilestoneDto(
    Guid Id,
    Guid ProjectId,
    string Title,
    string? Description,
    MilestoneType MilestoneType,
    DateTime? PlannedDate,
    DateTime? ActualDate,
    bool IsCompleted,
    string? Notes,
    DateTime CreatedAt
);

public record CreatePurchaseMilestoneRequest(
    string Title,
    string? Description,
    MilestoneType MilestoneType,
    DateTime? PlannedDate,
    string? Notes
);

public record UpdatePurchaseMilestoneRequest(
    string Title,
    string? Description,
    MilestoneType MilestoneType,
    DateTime? PlannedDate,
    DateTime? ActualDate,
    bool IsCompleted,
    string? Notes
);

// ── Service interface ───────────────────────────────────────────────────────────

public interface IPurchaseProjectService
{
    Task<IEnumerable<PurchaseProjectDto>> GetAllAsync(Guid userId);
    Task<PurchaseProjectDto?> GetByIdAsync(Guid id, Guid userId);
    Task<PurchaseProjectDto> CreateAsync(CreatePurchaseProjectRequest request, Guid userId);
    Task<PurchaseProjectDto?> UpdateAsync(Guid id, UpdatePurchaseProjectRequest request, Guid userId);
    Task<bool> DeleteAsync(Guid id, Guid userId);
    Task<IEnumerable<PurchaseMilestoneDto>> GetMilestonesAsync(Guid projectId, Guid userId);
    Task<PurchaseMilestoneDto> AddMilestoneAsync(Guid projectId, CreatePurchaseMilestoneRequest request, Guid userId);
    Task<PurchaseMilestoneDto?> UpdateMilestoneAsync(Guid projectId, Guid milestoneId, UpdatePurchaseMilestoneRequest request, Guid userId);
}
