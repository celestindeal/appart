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
    public decimal? MonthlyRent { get; set; }
    public decimal? PropertyTax { get; set; }
    public decimal? Insurance { get; set; }
    public decimal? MonthlyCharges { get; set; }
    public bool IsRented { get; set; }
    public PropertyStatus Status { get; set; }

    /// Nombre d'appartements dans l'immeuble (uniquement si PropertyType == Building).
    public int? ApartmentCount { get; set; }

    // Navigation properties
    public User User { get; set; } = null!;
    public ICollection<Tenant> Tenants { get; set; } = new List<Tenant>();
    public ICollection<PropertyDocument> PropertyDocuments { get; set; } = new List<PropertyDocument>();
    public PurchaseProject? PurchaseProject { get; set; }
    public ICollection<RenovationProject> RenovationProjects { get; set; } = new List<RenovationProject>();
    public ICollection<PropertyExpense> PropertyExpenses { get; set; } = new List<PropertyExpense>();
}
