using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Application.DTOs.Tenants;
using ImmoManager.Application.Services.Interfaces;

namespace ImmoManager.Api.Controllers;

/// Contrôleur REST pour la gestion des locataires.
/// Toutes les routes nécessitent un JWT valide.
/// L'ownership est dérivé du bien parent (Tenant.Property.UserId).
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

    /// GET /api/tenants — Liste tous les locataires de l'utilisateur.
    [HttpGet]
    [ProducesResponseType(typeof(List<TenantDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<List<TenantDto>>> GetAll()
    {
        var tenants = await _tenantService.GetAllAsync(GetUserId());
        return Ok(tenants);
    }

    /// GET /api/tenants/{id} — Récupère un locataire par son ID.
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

    /// POST /api/tenants — Crée un nouveau locataire.
    [HttpPost]
    [ProducesResponseType(typeof(TenantDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<TenantDto>> Create([FromBody] CreateTenantRequest request)
    {
        var tenant = await _tenantService.CreateAsync(request, GetUserId());
        return CreatedAtAction(nameof(GetById), new { id = tenant.Id }, tenant);
    }

    /// PUT /api/tenants/{id} — Met à jour un locataire existant.
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

    /// DELETE /api/tenants/{id} — Supprime un locataire.
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
}
