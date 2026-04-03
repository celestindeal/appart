using System.ComponentModel.DataAnnotations;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Renovation;

public class CreateRenovationRequest
{
    [Required]
    public Guid PropertyId { get; set; }

    [Required]
    [MaxLength(200)]
    public string ProjectName { get; set; } = string.Empty;

    [MaxLength(2000)]
    public string? Description { get; set; }

    public RenovationStatus Status { get; set; } = RenovationStatus.Planning;
    public DateTime? StartDate { get; set; }
    public DateTime? ExpectedEndDate { get; set; }

    [Required]
    [Range(0, double.MaxValue)]
    public decimal TotalBudget { get; set; }
}
