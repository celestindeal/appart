using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Application.DTOs.Documents;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/tenants/{tenantId:guid}/documents")]
public class TenantDocumentsController : ControllerBase
{
    private readonly ITenantDocumentService _service;

    public TenantDocumentsController(ITenantDocumentService service)
    {
        _service = service;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    /// GET /api/tenants/{tenantId}/documents
    [HttpGet]
    [ProducesResponseType(typeof(List<DocumentDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<List<DocumentDto>>> GetByTenant(Guid tenantId)
    {
        var docs = await _service.GetByTenantAsync(tenantId, GetUserId());
        return Ok(docs);
    }

    /// POST /api/tenants/{tenantId}/documents (multipart)
    [HttpPost]
    [RequestSizeLimit(50 * 1024 * 1024)] // 50 MB
    [ProducesResponseType(typeof(DocumentDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<DocumentDto>> Upload(
        Guid tenantId,
        [FromForm] IFormFile file,
        [FromForm] DocumentType documentType)
    {
        if (file == null || file.Length == 0)
            return BadRequest(new { message = "Fichier manquant ou vide." });

        try
        {
            var doc = await _service.UploadAsync(tenantId, file, documentType, GetUserId());
            return StatusCode(StatusCodes.Status201Created, doc);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    /// DELETE /api/tenants/{tenantId}/documents/{documentId}
    [HttpDelete("{documentId:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid tenantId, Guid documentId)
    {
        var deleted = await _service.DeleteAsync(documentId, GetUserId());
        if (!deleted) return NotFound();
        return NoContent();
    }
}
