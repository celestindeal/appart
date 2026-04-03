using ImmoManager.Domain.Common;

namespace ImmoManager.Domain.Entities;

public class PropertyDocument : BaseEntity
{
    public Guid PropertyId { get; set; }
    public string DocumentName { get; set; } = string.Empty;
    public string DocumentType { get; set; } = string.Empty;
    public string StorageUrl { get; set; } = string.Empty;
    public long? FileSize { get; set; }

    // Navigation properties
    public Property Property { get; set; } = null!;
}
