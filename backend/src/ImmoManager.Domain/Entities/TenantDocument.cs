using ImmoManager.Domain.Common;

namespace ImmoManager.Domain.Entities;

public class TenantDocument : BaseEntity
{
    public Guid TenantId { get; set; }
    public string DocumentType { get; set; } = string.Empty;
    public string FileName { get; set; } = string.Empty;
    public string FileUrl { get; set; } = string.Empty;
    public long? FileSize { get; set; }

    // Navigation properties
    public Tenant Tenant { get; set; } = null!;
}
