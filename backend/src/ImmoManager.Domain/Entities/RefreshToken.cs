using ImmoManager.Domain.Common;

namespace ImmoManager.Domain.Entities;

public class RefreshToken : BaseEntity
{
    public Guid UserId { get; set; }
    public string Token { get; set; } = string.Empty;
    public DateTime ExpiryDate { get; set; }
    public bool IsRevoked { get; set; }
    public string? CreatedByIp { get; set; }

    // Navigation properties
    public User User { get; set; } = null!;
}
