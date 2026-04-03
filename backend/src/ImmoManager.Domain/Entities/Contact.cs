using ImmoManager.Domain.Common;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Entities;

public class Contact : BaseEntity
{
    public Guid UserId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? PhoneNumber { get; set; }
    public ContactType ContactType { get; set; }
    public string? CompanyName { get; set; }
    public string? Address { get; set; }
    public string? Notes { get; set; }

    // Navigation properties
    public User User { get; set; } = null!;
}
