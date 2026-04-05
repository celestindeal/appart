using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Entities;

/// Événement dans la timeline d'un bien immobilier.
/// Permet de tracer l'historique : locataires, travaux, autres.
public class PropertyEvent
{
    public Guid Id { get; set; }
    public Guid PropertyId { get; set; }
    public Guid UserId { get; set; }

    /// Type d'événement (Tenant, Renovation, Other).
    public PropertyEventType EventType { get; set; }

    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }

    /// Date de début de l'événement.
    public DateTime StartDate { get; set; }

    /// Date de fin (null = toujours en cours).
    public DateTime? EndDate { get; set; }

    // ── Champs spécifiques locataire ──
    public decimal? MonthlyRent { get; set; }
    public decimal? DepositAmount { get; set; }

    // ── Champs spécifiques travaux ──
    public decimal? Cost { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public Property Property { get; set; } = null!;
    public User User { get; set; } = null!;
}
