using System.ComponentModel.DataAnnotations;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.DTOs.Business;

public class CreateAccountingEntryRequest
{
    public Guid? PropertyId { get; set; }

    [Required]
    public EntryType EntryType { get; set; }

    [Required]
    [Range(0.01, double.MaxValue)]
    public decimal Amount { get; set; }

    [Required]
    public DateTime EntryDate { get; set; }

    [MaxLength(500)]
    public string? Description { get; set; }

    [Required]
    public ExpenseCategory Category { get; set; }

    [MaxLength(1000)]
    public string? Notes { get; set; }
}
