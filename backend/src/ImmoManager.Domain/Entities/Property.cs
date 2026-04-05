using ImmoManager.Domain.Common;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Entities;

public class Property : BaseEntity
{
    public Guid UserId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string Address { get; set; } = string.Empty;
    public string? PostalCode { get; set; }
    public string City { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public double? Latitude { get; set; }
    public double? Longitude { get; set; }
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

    /// ID du bien parent (ex : l'immeuble auquel appartient cet appartement).
    /// Null si le bien est un bien racine (pas contenu dans un autre).
    public Guid? ParentPropertyId { get; set; }

    // Navigation properties

    /// Bien parent (immeuble) si cet appartement en fait partie.
    public Property? ParentProperty { get; set; }

    /// Liste des appartements contenus dans cet immeuble.
    public ICollection<Property> Apartments { get; set; } = new List<Property>();

    public User User { get; set; } = null!;
    public ICollection<Tenant> Tenants { get; set; } = new List<Tenant>();
    public ICollection<PropertyDocument> PropertyDocuments { get; set; } = new List<PropertyDocument>();
    public PurchaseProject? PurchaseProject { get; set; }
    public ICollection<RenovationProject> RenovationProjects { get; set; } = new List<RenovationProject>();
    public ICollection<PropertyExpense> PropertyExpenses { get; set; } = new List<PropertyExpense>();
    public ICollection<PropertyEvent> Events { get; set; } = new List<PropertyEvent>();
}
