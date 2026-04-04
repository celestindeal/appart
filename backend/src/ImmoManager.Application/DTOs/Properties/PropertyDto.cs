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
    public decimal? MonthlyRent { get; set; }
    public decimal? PropertyTax { get; set; }
    public decimal? Insurance { get; set; }
    public decimal? MonthlyCharges { get; set; }
    public bool IsRented { get; set; }
    public PropertyStatus Status { get; set; }

    /// Nombre d'appartements (uniquement pour les immeubles).
    public int? ApartmentCount { get; set; }

    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
