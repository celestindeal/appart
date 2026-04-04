using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Application.DTOs.Properties;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Api.Controllers;

/// Contrôleur REST pour la gestion des biens immobiliers.
/// Toutes les routes nécessitent un JWT valide.
/// Chaque utilisateur ne voit que ses propres biens.
[Authorize]
[ApiController]
[Route("api/[controller]")]
public class PropertiesController : ControllerBase
{
    private readonly IPropertyService _propertyService;

    public PropertiesController(IPropertyService propertyService)
    {
        _propertyService = propertyService;
    }

    /// Extrait l'ID de l'utilisateur connecté depuis le JWT.
    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    /// GET /api/properties — Liste tous les biens de l'utilisateur (avec filtres optionnels).
    [HttpGet]
    [ProducesResponseType(typeof(List<PropertyDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<List<PropertyDto>>> GetAll(
        [FromQuery] string? search,
        [FromQuery] PropertyType? type,
        [FromQuery] PropertyStatus? status,
        [FromQuery] string? city)
    {
        var properties = await _propertyService.GetAllAsync(GetUserId(), search, type, status, city);
        return Ok(properties);
    }

    /// GET /api/properties/{id} — Récupère un bien par son ID.
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(PropertyDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<PropertyDto>> GetById(Guid id)
    {
        var property = await _propertyService.GetByIdAsync(id, GetUserId());
        if (property is null)
            return NotFound();

        return Ok(property);
    }

    /// POST /api/properties — Crée un nouveau bien.
    [HttpPost]
    [ProducesResponseType(typeof(PropertyDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<PropertyDto>> Create([FromBody] CreatePropertyRequest request)
    {
        var property = await _propertyService.CreateAsync(request, GetUserId());
        return CreatedAtAction(nameof(GetById), new { id = property.Id }, property);
    }

    /// PUT /api/properties/{id} — Met à jour un bien existant.
    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(PropertyDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<PropertyDto>> Update(Guid id, [FromBody] UpdatePropertyRequest request)
    {
        var property = await _propertyService.UpdateAsync(id, request, GetUserId());
        if (property is null)
            return NotFound();

        return Ok(property);
    }

    /// DELETE /api/properties/{id} — Supprime un bien.
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _propertyService.DeleteAsync(id, GetUserId());
        if (!deleted)
            return NotFound();

        return NoContent();
    }
}
