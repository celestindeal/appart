using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Business;

public class ContactDto
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? PhoneNumber { get; set; }
    public ContactType ContactType { get; set; }
    public string? CompanyName { get; set; }
    public string? Address { get; set; }
    public string? Notes { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
