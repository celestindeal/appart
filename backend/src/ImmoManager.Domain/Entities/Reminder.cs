using ImmoManager.Domain.Common;

namespace ImmoManager.Domain.Entities;

public class Reminder : BaseEntity
{
    public Guid TenantId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string ReminderType { get; set; } = string.Empty;
    public DateTime ReminderDate { get; set; }
    public bool IsCompleted { get; set; }

    // Navigation properties
    public Tenant Tenant { get; set; } = null!;
}
