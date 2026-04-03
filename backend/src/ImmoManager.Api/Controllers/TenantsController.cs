using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class TenantsController : ControllerBase
{
    private readonly ITenantService _tenantService;

    public TenantsController(ITenantService tenantService)
    {
        _tenantService = tenantService;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    // ── Tenants CRUD ────────────────────────────────────────────────────────────

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<TenantDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<TenantDto>>> GetAll()
    {
        var tenants = await _tenantService.GetAllAsync(GetUserId());
        return Ok(tenants);
    }

    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(TenantDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<TenantDto>> GetById(Guid id)
    {
        var tenant = await _tenantService.GetByIdAsync(id, GetUserId());
        if (tenant is null)
            return NotFound();

        return Ok(tenant);
    }

    [HttpPost]
    [ProducesResponseType(typeof(TenantDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<TenantDto>> Create([FromBody] CreateTenantRequest request)
    {
        var tenant = await _tenantService.CreateAsync(request, GetUserId());
        return CreatedAtAction(nameof(GetById), new { id = tenant.Id }, tenant);
    }

    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(TenantDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<TenantDto>> Update(Guid id, [FromBody] UpdateTenantRequest request)
    {
        var tenant = await _tenantService.UpdateAsync(id, request, GetUserId());
        if (tenant is null)
            return NotFound();

        return Ok(tenant);
    }

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _tenantService.DeleteAsync(id, GetUserId());
        if (!deleted)
            return NotFound();

        return NoContent();
    }

    // ── Payments ────────────────────────────────────────────────────────────────

    [HttpGet("{id:guid}/payments")]
    [ProducesResponseType(typeof(IEnumerable<RentPaymentDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<RentPaymentDto>>> GetPayments(Guid id)
    {
        var payments = await _tenantService.GetPaymentsAsync(id, GetUserId());
        return Ok(payments);
    }

    [HttpPost("{id:guid}/payments")]
    [ProducesResponseType(typeof(RentPaymentDto), StatusCodes.Status201Created)]
    public async Task<ActionResult<RentPaymentDto>> AddPayment(Guid id, [FromBody] CreateRentPaymentRequest request)
    {
        var payment = await _tenantService.AddPaymentAsync(id, request, GetUserId());
        return CreatedAtAction(nameof(GetPayments), new { id }, payment);
    }

    // ── Documents ───────────────────────────────────────────────────────────────

    [HttpGet("{id:guid}/documents")]
    [ProducesResponseType(typeof(IEnumerable<TenantDocumentDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<TenantDocumentDto>>> GetDocuments(Guid id)
    {
        var documents = await _tenantService.GetDocumentsAsync(id, GetUserId());
        return Ok(documents);
    }

    [HttpPost("{id:guid}/documents")]
    [ProducesResponseType(typeof(TenantDocumentDto), StatusCodes.Status201Created)]
    public async Task<ActionResult<TenantDocumentDto>> UploadDocument(Guid id, [FromBody] CreateTenantDocumentRequest request)
    {
        var document = await _tenantService.AddDocumentAsync(id, request, GetUserId());
        return CreatedAtAction(nameof(GetDocuments), new { id }, document);
    }

    // ── Reminders ───────────────────────────────────────────────────────────────

    [HttpGet("{id:guid}/reminders")]
    [ProducesResponseType(typeof(IEnumerable<ReminderDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<ReminderDto>>> GetReminders(Guid id)
    {
        var reminders = await _tenantService.GetRemindersAsync(id, GetUserId());
        return Ok(reminders);
    }

    [HttpPost("{id:guid}/reminders")]
    [ProducesResponseType(typeof(ReminderDto), StatusCodes.Status201Created)]
    public async Task<ActionResult<ReminderDto>> AddReminder(Guid id, [FromBody] CreateReminderRequest request)
    {
        var reminder = await _tenantService.AddReminderAsync(id, request, GetUserId());
        return CreatedAtAction(nameof(GetReminders), new { id }, reminder);
    }
}

// ── DTOs ────────────────────────────────────────────────────────────────────────

public record TenantDto(
    Guid Id,
    Guid PropertyId,
    string FirstName,
    string LastName,
    string Email,
    string? PhoneNumber,
    string? IdentityDocumentType,
    string? IdentityDocumentNumber,
    DateTime MoveInDate,
    DateTime? MoveOutDate,
    decimal MonthlyRent,
    decimal? DepositAmount,
    DateTime? DepositReturnedDate,
    TenantStatus Status,
    DateTime CreatedAt,
    DateTime UpdatedAt
);

public record CreateTenantRequest(
    Guid PropertyId,
    string FirstName,
    string LastName,
    string Email,
    string? PhoneNumber,
    string? IdentityDocumentType,
    string? IdentityDocumentNumber,
    DateTime MoveInDate,
    DateTime? MoveOutDate,
    decimal MonthlyRent,
    decimal? DepositAmount,
    TenantStatus Status
);

public record UpdateTenantRequest(
    string FirstName,
    string LastName,
    string Email,
    string? PhoneNumber,
    string? IdentityDocumentType,
    string? IdentityDocumentNumber,
    DateTime MoveInDate,
    DateTime? MoveOutDate,
    decimal MonthlyRent,
    decimal? DepositAmount,
    DateTime? DepositReturnedDate,
    TenantStatus Status
);

public record RentPaymentDto(
    Guid Id,
    Guid TenantId,
    Guid PropertyId,
    decimal Amount,
    DateTime PaymentDueDate,
    DateTime? PaymentDate,
    PaymentMethod? PaymentMethod,
    PaymentStatus Status,
    string? Notes,
    DateTime CreatedAt
);

public record CreateRentPaymentRequest(
    Guid PropertyId,
    decimal Amount,
    DateTime PaymentDueDate,
    DateTime? PaymentDate,
    PaymentMethod? PaymentMethod,
    PaymentStatus Status,
    string? Notes
);

public record TenantDocumentDto(
    Guid Id,
    Guid TenantId,
    string DocumentType,
    string FileName,
    string FileUrl,
    long? FileSize,
    DateTime CreatedAt
);

public record CreateTenantDocumentRequest(
    string DocumentType,
    string FileName,
    string FileUrl,
    long? FileSize
);

public record ReminderDto(
    Guid Id,
    Guid TenantId,
    string Title,
    string? Description,
    string ReminderType,
    DateTime ReminderDate,
    bool IsCompleted,
    DateTime CreatedAt
);

public record CreateReminderRequest(
    string Title,
    string? Description,
    string ReminderType,
    DateTime ReminderDate
);

// ── Service interface ───────────────────────────────────────────────────────────

public interface ITenantService
{
    Task<IEnumerable<TenantDto>> GetAllAsync(Guid userId);
    Task<TenantDto?> GetByIdAsync(Guid id, Guid userId);
    Task<TenantDto> CreateAsync(CreateTenantRequest request, Guid userId);
    Task<TenantDto?> UpdateAsync(Guid id, UpdateTenantRequest request, Guid userId);
    Task<bool> DeleteAsync(Guid id, Guid userId);
    Task<IEnumerable<RentPaymentDto>> GetPaymentsAsync(Guid tenantId, Guid userId);
    Task<RentPaymentDto> AddPaymentAsync(Guid tenantId, CreateRentPaymentRequest request, Guid userId);
    Task<IEnumerable<TenantDocumentDto>> GetDocumentsAsync(Guid tenantId, Guid userId);
    Task<TenantDocumentDto> AddDocumentAsync(Guid tenantId, CreateTenantDocumentRequest request, Guid userId);
    Task<IEnumerable<ReminderDto>> GetRemindersAsync(Guid tenantId, Guid userId);
    Task<ReminderDto> AddReminderAsync(Guid tenantId, CreateReminderRequest request, Guid userId);
}
