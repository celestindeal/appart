using System.ComponentModel.DataAnnotations;

namespace ImmoManager.Application.DTOs.Reminders;

public class UpdateReminderRequest
{
    [Required]
    [MaxLength(200)]
    public string Title { get; set; } = string.Empty;

    public string? Description { get; set; }

    [Required]
    public string ReminderType { get; set; } = string.Empty;

    [Required]
    public DateTime ReminderDate { get; set; }

    public bool IsCompleted { get; set; }
}
