using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Documents;

/// DTO unifié pour un document (locataire ou bien).
public class DocumentDto
{
    public Guid Id { get; set; }
    public Guid OwnerId { get; set; } // TenantId ou PropertyId
    public string FileName { get; set; } = string.Empty;
    public DocumentType DocumentType { get; set; }
    public string FileUrl { get; set; } = string.Empty;
    public long? FileSize { get; set; }
    public DateTime UploadedAt { get; set; }
}
