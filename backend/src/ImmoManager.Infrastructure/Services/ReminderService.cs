using Microsoft.EntityFrameworkCore;
using ImmoManager.Application.DTOs.Reminders;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Entities;
using ImmoManager.Infrastructure.Persistence;

namespace ImmoManager.Infrastructure.Services;

public class ReminderService : IReminderService
{
    private readonly ImmoManagerDbContext _context;

    public ReminderService(ImmoManagerDbContext context)
    {
        _context = context;
    }

    public async Task<List<ReminderDto>> GetByTenantAsync(Guid tenantId, Guid userId)
    {
        var reminders = await _context.Reminders
            .Include(r => r.Tenant).ThenInclude(t => t.Property)
            .Where(r => r.TenantId == tenantId && r.Tenant.Property.UserId == userId)
            .OrderByDescending(r => r.ReminderDate)
            .ToListAsync();

        return reminders.Select(MapToDto).ToList();
    }

    public async Task<ReminderDto?> GetByIdAsync(Guid id, Guid userId)
    {
        var reminder = await _context.Reminders
            .Include(r => r.Tenant).ThenInclude(t => t.Property)
            .FirstOrDefaultAsync(r => r.Id == id && r.Tenant.Property.UserId == userId);

        return reminder == null ? null : MapToDto(reminder);
    }

    public async Task<ReminderDto> CreateAsync(CreateReminderRequest request, Guid userId)
    {
        var tenant = await _context.Tenants
            .Include(t => t.Property)
            .FirstOrDefaultAsync(t => t.Id == request.TenantId && t.Property.UserId == userId);

        if (tenant == null)
            throw new ArgumentException("Le locataire n'existe pas.");

        var reminder = new Reminder
        {
            TenantId = request.TenantId,
            Title = request.Title,
            Description = request.Description,
            ReminderType = request.ReminderType,
            ReminderDate = request.ReminderDate,
            IsCompleted = request.IsCompleted,
        };

        _context.Reminders.Add(reminder);
        await _context.SaveChangesAsync();

        return MapToDto(reminder);
    }

    public async Task<ReminderDto?> UpdateAsync(Guid id, UpdateReminderRequest request, Guid userId)
    {
        var reminder = await _context.Reminders
            .Include(r => r.Tenant).ThenInclude(t => t.Property)
            .FirstOrDefaultAsync(r => r.Id == id && r.Tenant.Property.UserId == userId);

        if (reminder == null) return null;

        reminder.Title = request.Title;
        reminder.Description = request.Description;
        reminder.ReminderType = request.ReminderType;
        reminder.ReminderDate = request.ReminderDate;
        reminder.IsCompleted = request.IsCompleted;

        await _context.SaveChangesAsync();

        return MapToDto(reminder);
    }

    public async Task<bool> DeleteAsync(Guid id, Guid userId)
    {
        var reminder = await _context.Reminders
            .Include(r => r.Tenant).ThenInclude(t => t.Property)
            .FirstOrDefaultAsync(r => r.Id == id && r.Tenant.Property.UserId == userId);

        if (reminder == null) return false;

        _context.Reminders.Remove(reminder);
        await _context.SaveChangesAsync();

        return true;
    }

    private static ReminderDto MapToDto(Reminder r) => new()
    {
        Id = r.Id,
        TenantId = r.TenantId,
        Title = r.Title,
        Description = r.Description,
        ReminderType = r.ReminderType,
        ReminderDate = r.ReminderDate,
        IsCompleted = r.IsCompleted,
        CreatedAt = r.CreatedAt,
        UpdatedAt = r.UpdatedAt,
    };
}
