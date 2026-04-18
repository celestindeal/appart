using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Application.DTOs.Documents;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/properties/{propertyId:guid}/documents")]
public class PropertyDocumentsController : ControllerBase
{
    private readonly IPropertyDocumentService _service;

    public PropertyDocumentsController(IPropertyDocumentService service)
    {
        _service = service;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    /// GET /api/properties/{propertyId}/documents
    [HttpGet]
    [ProducesResponseType(typeof(List<DocumentDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<List<DocumentDto>>> GetByProperty(Guid propertyId)
    {
        var docs = await _service.GetByPropertyAsync(propertyId, GetUserId());
        return Ok(docs);
    }

    /// POST /api/properties/{propertyId}/documents (multipart)
    [HttpPost]
    [RequestSizeLimit(50 * 1024 * 1024)] // 50 MB
    [ProducesResponseType(typeof(DocumentDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<DocumentDto>> Upload(
        Guid propertyId,
        [FromForm] IFormFile file,
        [FromForm] DocumentType documentType)
    {
        if (file == null || file.Length == 0)
            return BadRequest(new { message = "Fichier manquant ou vide." });

        try
        {
            var doc = await _service.UploadAsync(propertyId, file, documentType, GetUserId());
            return StatusCode(StatusCodes.Status201Created, doc);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    /// DELETE /api/properties/{propertyId}/documents/{documentId}
    [HttpDelete("{documentId:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid propertyId, Guid documentId)
    {
        var deleted = await _service.DeleteAsync(documentId, GetUserId());
        if (!deleted) return NotFound();
        return NoContent();
    }
}
