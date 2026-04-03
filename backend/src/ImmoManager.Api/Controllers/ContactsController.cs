using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class ContactsController : ControllerBase
{
    private readonly IContactService _contactService;

    public ContactsController(IContactService contactService)
    {
        _contactService = contactService;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    /// <summary>
    /// List contacts with optional type filter and search.
    /// </summary>
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<ContactDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<ContactDto>>> GetAll(
        [FromQuery] ContactType? type,
        [FromQuery] string? search)
    {
        var contacts = await _contactService.GetAllAsync(GetUserId(), type, search);
        return Ok(contacts);
    }

    /// <summary>
    /// Get a contact by its identifier.
    /// </summary>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(ContactDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ContactDto>> GetById(Guid id)
    {
        var contact = await _contactService.GetByIdAsync(id, GetUserId());
        if (contact is null)
            return NotFound();

        return Ok(contact);
    }

    /// <summary>
    /// Create a new contact.
    /// </summary>
    [HttpPost]
    [ProducesResponseType(typeof(ContactDto), StatusCodes.Status201Created)]
    public async Task<ActionResult<ContactDto>> Create([FromBody] CreateContactRequest request)
    {
        var contact = await _contactService.CreateAsync(request, GetUserId());
        return CreatedAtAction(nameof(GetById), new { id = contact.Id }, contact);
    }

    /// <summary>
    /// Update a contact.
    /// </summary>
    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(ContactDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ContactDto>> Update(Guid id, [FromBody] UpdateContactRequest request)
    {
        var contact = await _contactService.UpdateAsync(id, request, GetUserId());
        if (contact is null)
            return NotFound();

        return Ok(contact);
    }

    /// <summary>
    /// Delete a contact.
    /// </summary>
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _contactService.DeleteAsync(id, GetUserId());
        if (!deleted)
            return NotFound();

        return NoContent();
    }
}

// ── DTOs ────────────────────────────────────────────────────────────────────────

public record ContactDto(
    Guid Id,
    string Name,
    string? Email,
    string? PhoneNumber,
    ContactType ContactType,
    string? CompanyName,
    string? Address,
    string? Notes,
    DateTime CreatedAt,
    DateTime UpdatedAt
);

public record CreateContactRequest(
    string Name,
    string? Email,
    string? PhoneNumber,
    ContactType ContactType,
    string? CompanyName,
    string? Address,
    string? Notes
);

public record UpdateContactRequest(
    string Name,
    string? Email,
    string? PhoneNumber,
    ContactType ContactType,
    string? CompanyName,
    string? Address,
    string? Notes
);

// ── Service interface ───────────────────────────────────────────────────────────

public interface IContactService
{
    Task<IEnumerable<ContactDto>> GetAllAsync(Guid userId, ContactType? type, string? search);
    Task<ContactDto?> GetByIdAsync(Guid id, Guid userId);
    Task<ContactDto> CreateAsync(CreateContactRequest request, Guid userId);
    Task<ContactDto?> UpdateAsync(Guid id, UpdateContactRequest request, Guid userId);
    Task<bool> DeleteAsync(Guid id, Guid userId);
}
