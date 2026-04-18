using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Application.DTOs.Reminders;
using ImmoManager.Application.Services.Interfaces;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class RemindersController : ControllerBase
{
    private readonly IReminderService _reminderService;

    public RemindersController(IReminderService reminderService)
    {
        _reminderService = reminderService;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    /// GET /api/reminders?tenantId={id}
    [HttpGet]
    [ProducesResponseType(typeof(List<ReminderDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<List<ReminderDto>>> GetByTenant([FromQuery] Guid tenantId)
    {
        var reminders = await _reminderService.GetByTenantAsync(tenantId, GetUserId());
        return Ok(reminders);
    }

    /// GET /api/reminders/{id}
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(ReminderDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ReminderDto>> GetById(Guid id)
    {
        var reminder = await _reminderService.GetByIdAsync(id, GetUserId());
        if (reminder is null) return NotFound();
        return Ok(reminder);
    }

    /// POST /api/reminders
    [HttpPost]
    [ProducesResponseType(typeof(ReminderDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<ReminderDto>> Create([FromBody] CreateReminderRequest request)
    {
        try
        {
            var reminder = await _reminderService.CreateAsync(request, GetUserId());
            return CreatedAtAction(nameof(GetById), new { id = reminder.Id }, reminder);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    /// PUT /api/reminders/{id}
    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(ReminderDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ReminderDto>> Update(Guid id, [FromBody] UpdateReminderRequest request)
    {
        var reminder = await _reminderService.UpdateAsync(id, request, GetUserId());
        if (reminder is null) return NotFound();
        return Ok(reminder);
    }

    /// DELETE /api/reminders/{id}
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _reminderService.DeleteAsync(id, GetUserId());
        if (!deleted) return NotFound();
        return NoContent();
    }
}
