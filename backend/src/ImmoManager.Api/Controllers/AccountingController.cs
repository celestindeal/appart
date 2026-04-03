using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class AccountingController : ControllerBase
{
    private readonly IAccountingService _accountingService;

    public AccountingController(IAccountingService accountingService)
    {
        _accountingService = accountingService;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    /// <summary>
    /// List accounting entries with optional filters.
    /// </summary>
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<AccountingEntryDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<AccountingEntryDto>>> GetAll(
        [FromQuery] DateTime? from,
        [FromQuery] DateTime? to,
        [FromQuery] EntryType? type,
        [FromQuery] ExpenseCategory? category,
        [FromQuery] Guid? propertyId)
    {
        var entries = await _accountingService.GetAllAsync(GetUserId(), from, to, type, category, propertyId);
        return Ok(entries);
    }

    /// <summary>
    /// Get an accounting entry by its identifier.
    /// </summary>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(AccountingEntryDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<AccountingEntryDto>> GetById(Guid id)
    {
        var entry = await _accountingService.GetByIdAsync(id, GetUserId());
        if (entry is null)
            return NotFound();

        return Ok(entry);
    }

    /// <summary>
    /// Create a new accounting entry.
    /// </summary>
    [HttpPost]
    [ProducesResponseType(typeof(AccountingEntryDto), StatusCodes.Status201Created)]
    public async Task<ActionResult<AccountingEntryDto>> Create([FromBody] CreateAccountingEntryRequest request)
    {
        var entry = await _accountingService.CreateAsync(request, GetUserId());
        return CreatedAtAction(nameof(GetById), new { id = entry.Id }, entry);
    }

    /// <summary>
    /// Update an accounting entry.
    /// </summary>
    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(AccountingEntryDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<AccountingEntryDto>> Update(Guid id, [FromBody] UpdateAccountingEntryRequest request)
    {
        var entry = await _accountingService.UpdateAsync(id, request, GetUserId());
        if (entry is null)
            return NotFound();

        return Ok(entry);
    }

    /// <summary>
    /// Delete an accounting entry.
    /// </summary>
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _accountingService.DeleteAsync(id, GetUserId());
        if (!deleted)
            return NotFound();

        return NoContent();
    }

    /// <summary>
    /// Get a financial summary for the authenticated user.
    /// </summary>
    [HttpGet("summary")]
    [ProducesResponseType(typeof(FinancialSummaryDto), StatusCodes.Status200OK)]
    public async Task<ActionResult<FinancialSummaryDto>> GetSummary(
        [FromQuery] DateTime? from,
        [FromQuery] DateTime? to,
        [FromQuery] Guid? propertyId)
    {
        var summary = await _accountingService.GetSummaryAsync(GetUserId(), from, to, propertyId);
        return Ok(summary);
    }
}

// ── DTOs ────────────────────────────────────────────────────────────────────────

public record AccountingEntryDto(
    Guid Id,
    Guid UserId,
    Guid? PropertyId,
    EntryType EntryType,
    decimal Amount,
    DateTime EntryDate,
    string? Description,
    ExpenseCategory Category,
    string? Notes,
    DateTime CreatedAt,
    DateTime UpdatedAt
);

public record CreateAccountingEntryRequest(
    Guid? PropertyId,
    EntryType EntryType,
    decimal Amount,
    DateTime EntryDate,
    string? Description,
    ExpenseCategory Category,
    string? Notes
);

public record UpdateAccountingEntryRequest(
    Guid? PropertyId,
    EntryType EntryType,
    decimal Amount,
    DateTime EntryDate,
    string? Description,
    ExpenseCategory Category,
    string? Notes
);

public record FinancialSummaryDto(
    decimal TotalIncome,
    decimal TotalExpenses,
    decimal NetResult,
    decimal AverageMonthlyIncome,
    decimal AverageMonthlyExpenses,
    IDictionary<string, decimal> IncomeByCategory,
    IDictionary<string, decimal> ExpensesByCategory
);

// ── Service interface ───────────────────────────────────────────────────────────

public interface IAccountingService
{
    Task<IEnumerable<AccountingEntryDto>> GetAllAsync(Guid userId, DateTime? from, DateTime? to, EntryType? type, ExpenseCategory? category, Guid? propertyId);
    Task<AccountingEntryDto?> GetByIdAsync(Guid id, Guid userId);
    Task<AccountingEntryDto> CreateAsync(CreateAccountingEntryRequest request, Guid userId);
    Task<AccountingEntryDto?> UpdateAsync(Guid id, UpdateAccountingEntryRequest request, Guid userId);
    Task<bool> DeleteAsync(Guid id, Guid userId);
    Task<FinancialSummaryDto> GetSummaryAsync(Guid userId, DateTime? from, DateTime? to, Guid? propertyId);
}
