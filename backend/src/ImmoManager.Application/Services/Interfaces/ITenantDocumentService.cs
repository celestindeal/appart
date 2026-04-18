using Microsoft.AspNetCore.Http;
using ImmoManager.Application.DTOs.Documents;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.Services.Interfaces;

public interface ITenantDocumentService
{
    Task<List<DocumentDto>> GetByTenantAsync(Guid tenantId, Guid userId);
    Task<DocumentDto> UploadAsync(Guid tenantId, IFormFile file, DocumentType type, Guid userId);
    Task<bool> DeleteAsync(Guid documentId, Guid userId);
}
