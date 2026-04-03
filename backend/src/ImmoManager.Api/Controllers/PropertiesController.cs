using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class PropertiesController : ControllerBase
{
    private readonly IPropertyService _propertyService;

    public PropertiesController(IPropertyService propertyService)
    {
        _propertyService = propertyService;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    /// <summary>
    /// List all properties for the authenticated user with optional search/filter.
    /// </summary>
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<PropertyDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<PropertyDto>>> GetAll(
        [FromQuery] string? search,
        [FromQuery] PropertyType? type,
        [FromQuery] PropertyStatus? status,
        [FromQuery] string? city)
    {
        var properties = await _propertyService.GetAllAsync(GetUserId(), search, type, status, city);
        return Ok(properties);
    }

    /// <summary>
    /// Get a property by its identifier.
    /// </summary>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(PropertyDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<PropertyDto>> GetById(Guid id)
    {
        var property = await _propertyService.GetByIdAsync(id, GetUserId());
        if (property is null)
            return NotFound();

        return Ok(property);
    }

    /// <summary>
    /// Create a new property.
    /// </summary>
    [HttpPost]
    [ProducesResponseType(typeof(PropertyDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<PropertyDto>> Create([FromBody] CreatePropertyRequest request)
    {
        var property = await _propertyService.CreateAsync(request, GetUserId());
        return CreatedAtAction(nameof(GetById), new { id = property.Id }, property);
    }

    /// <summary>
    /// Update an existing property.
    /// </summary>
    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(PropertyDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<PropertyDto>> Update(Guid id, [FromBody] UpdatePropertyRequest request)
    {
        var property = await _propertyService.UpdateAsync(id, request, GetUserId());
        if (property is null)
            return NotFound();

        return Ok(property);
    }

    /// <summary>
    /// Delete a property.
    /// </summary>
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _propertyService.DeleteAsync(id, GetUserId());
        if (!deleted)
            return NotFound();

        return NoContent();
    }

    /// <summary>
    /// Calculate profitability metrics for a given property configuration.
    /// </summary>
    [HttpPost("calculate-profitability")]
    [ProducesResponseType(typeof(ProfitabilityResponse), StatusCodes.Status200OK)]
    public ActionResult<ProfitabilityResponse> CalculateProfitability([FromBody] ProfitabilityRequest request)
    {
        var response = _propertyService.CalculateProfitability(request);
        return Ok(response);
    }
}

// ── DTOs ────────────────────────────────────────────────────────────────────────

public record PropertyDto(
    Guid Id,
    string Name,
    string? Description,
    string Address,
    string? PostalCode,
    string City,
    string Country,
    double? Latitude,
    double? Longitude,
    PropertyType PropertyType,
    DateTime? AcquisitionDate,
    decimal AcquisitionPrice,
    decimal? CurrentValue,
    double? Surface,
    int? RoomCount,
    int? BathroomCount,
    int? ParkingSpaces,
    decimal? MonthlyRent,
    decimal? PropertyTax,
    decimal? Insurance,
    decimal? MonthlyCharges,
    bool IsRented,
    PropertyStatus Status,
    DateTime CreatedAt,
    DateTime UpdatedAt
);

public record CreatePropertyRequest(
    string Name,
    string? Description,
    string Address,
    string? PostalCode,
    string City,
    string Country,
    double? Latitude,
    double? Longitude,
    PropertyType PropertyType,
    DateTime? AcquisitionDate,
    decimal AcquisitionPrice,
    decimal? CurrentValue,
    double? Surface,
    int? RoomCount,
    int? BathroomCount,
    int? ParkingSpaces,
    decimal? MonthlyRent,
    decimal? PropertyTax,
    decimal? Insurance,
    decimal? MonthlyCharges,
    bool IsRented,
    PropertyStatus Status
);

public record UpdatePropertyRequest(
    string Name,
    string? Description,
    string Address,
    string? PostalCode,
    string City,
    string Country,
    double? Latitude,
    double? Longitude,
    PropertyType PropertyType,
    DateTime? AcquisitionDate,
    decimal AcquisitionPrice,
    decimal? CurrentValue,
    double? Surface,
    int? RoomCount,
    int? BathroomCount,
    int? ParkingSpaces,
    decimal? MonthlyRent,
    decimal? PropertyTax,
    decimal? Insurance,
    decimal? MonthlyCharges,
    bool IsRented,
    PropertyStatus Status
);

public record ProfitabilityRequest(
    decimal AcquisitionPrice,
    decimal? NotaryFees,
    decimal? AgencyFees,
    decimal? RenovationCosts,
    decimal MonthlyRent,
    decimal? MonthlyCharges,
    decimal? PropertyTax,
    decimal? Insurance,
    decimal? VacancyRatePercent
);

public record ProfitabilityResponse(
    decimal GrossYield,
    decimal NetYield,
    decimal AnnualGrossIncome,
    decimal AnnualNetIncome,
    decimal TotalInvestment,
    decimal MonthlyCashFlow
);

// ── Service interface ───────────────────────────────────────────────────────────

public interface IPropertyService
{
    Task<IEnumerable<PropertyDto>> GetAllAsync(Guid userId, string? search, PropertyType? type, PropertyStatus? status, string? city);
    Task<PropertyDto?> GetByIdAsync(Guid id, Guid userId);
    Task<PropertyDto> CreateAsync(CreatePropertyRequest request, Guid userId);
    Task<PropertyDto?> UpdateAsync(Guid id, UpdatePropertyRequest request, Guid userId);
    Task<bool> DeleteAsync(Guid id, Guid userId);
    ProfitabilityResponse CalculateProfitability(ProfitabilityRequest request);
}
