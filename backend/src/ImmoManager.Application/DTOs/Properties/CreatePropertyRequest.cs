using System.ComponentModel.DataAnnotations;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Properties;

public class CreatePropertyRequest
{
    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;

    [MaxLength(2000)]
    public string? Description { get; set; }

    [Required]
    [MaxLength(500)]
    public string Address { get; set; } = string.Empty;

    [MaxLength(10)]
    public string? PostalCode { get; set; }

    [Required]
    [MaxLength(100)]
    public string City { get; set; } = string.Empty;

    [Required]
    [MaxLength(100)]
    public string Country { get; set; } = string.Empty;

    public double? Latitude { get; set; }
    public double? Longitude { get; set; }

    [Required]
    public PropertyType PropertyType { get; set; }

    public DateTime? AcquisitionDate { get; set; }

    [Range(0, double.MaxValue)]
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
}
