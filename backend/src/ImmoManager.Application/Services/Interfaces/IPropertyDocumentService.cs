using Microsoft.AspNetCore.Http;
using ImmoManager.Application.DTOs.Documents;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.Services.Interfaces;

public interface IPropertyDocumentService
{
    Task<List<DocumentDto>> GetByPropertyAsync(Guid propertyId, Guid userId);
    Task<DocumentDto> UploadAsync(Guid propertyId, IFormFile file, DocumentType type, Guid userId);
    Task<bool> DeleteAsync(Guid documentId, Guid userId);
}
