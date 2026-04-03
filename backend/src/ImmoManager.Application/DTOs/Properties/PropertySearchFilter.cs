using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Properties;

public class PropertySearchFilter
{
    public string? Query { get; set; }
    public PropertyType? PropertyType { get; set; }
    public string? City { get; set; }
    public decimal? MinPrice { get; set; }
    public decimal? MaxPrice { get; set; }
    public double? MinSurface { get; set; }
    public double? MaxSurface { get; set; }
}
