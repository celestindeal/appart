using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Properties;

/// DTO de lecture d'un bien immobilier (renvoyé par l'API).
public class PropertyDto
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string Address { get; set; } = string.Empty;
    public string? PostalCode { get; set; }
    public string City { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public PropertyType PropertyType { get; set; }
    public DateTime? AcquisitionDate { get; set; }
    public decimal AcquisitionPrice { get; set; }
    public decimal? CurrentValue { get; set; }
    public double? Surface { get; set; }
    public int? RoomCount { get; set; }
    public int? BathroomCount { get; set; }
    public int? ParkingSpaces { get; set; }
    public decimal? PropertyTax { get; set; }
    public decimal? Insurance { get; set; }
    public decimal? MonthlyCharges { get; set; }
    public bool IsRented { get; set; }
    public PropertyStatus Status { get; set; }

    /// ID du bien parent (immeuble) si cet appartement en fait partie.
    public Guid? ParentPropertyId { get; set; }

    /// Liste des appartements contenus dans cet immeuble.
    /// Rempli uniquement pour les biens de type Building.
    public List<PropertyDto>? Apartments { get; set; }

    /// Liste des événements associés à ce bien (locataires, travaux, etc.).
    public List<PropertyEventDto>? Events { get; set; }

    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
