using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Application.DTOs.Properties;
using ImmoManager.Application.Services.Interfaces;

namespace ImmoManager.Api.Controllers;

/// Contrôleur pour la gestion des événements de biens immobiliers.
[Authorize]
[ApiController]
[Route("api/[controller]")]
public class PropertyEventsController : ControllerBase
{
    private readonly IPropertyEventService _service;

    public PropertyEventsController(IPropertyEventService service)
    {
        _service = service;
    }

    /// Récupère l'ID de l'utilisateur connecté.
    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    /// Crée un nouvel événement sur un bien.
    [HttpPost]
    public async Task<ActionResult<PropertyEventDto>> Create([FromBody] CreatePropertyEventRequest request)
    {
        var result = await _service.CreateAsync(request, GetUserId());
        return CreatedAtAction(null, new { id = result.Id }, result);
    }

    /// Supprime un événement par son ID.
    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _service.DeleteAsync(id, GetUserId());
        if (!deleted) return NotFound();
        return NoContent();
    }
}
