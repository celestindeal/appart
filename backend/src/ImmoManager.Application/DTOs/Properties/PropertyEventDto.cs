using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Properties;

/// DTO de lecture d'un événement de bien immobilier.
public class PropertyEventDto
{
    public Guid Id { get; set; }
    public Guid PropertyId { get; set; }
    public PropertyEventType EventType { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public decimal? MonthlyRent { get; set; }
    public decimal? DepositAmount { get; set; }
    public decimal? Cost { get; set; }
    public bool IsActive => EndDate == null;
    public DateTime CreatedAt { get; set; }
}
