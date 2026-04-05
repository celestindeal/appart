using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Properties;

/// Données envoyées par le client pour créer un événement sur un bien.
public class CreatePropertyEventRequest
{
    public Guid PropertyId { get; set; }
    public PropertyEventType EventType { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public decimal? MonthlyRent { get; set; }
    public decimal? DepositAmount { get; set; }
    public decimal? Cost { get; set; }
}
