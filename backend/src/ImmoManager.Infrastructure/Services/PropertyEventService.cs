using Microsoft.EntityFrameworkCore;
using ImmoManager.Application.DTOs.Properties;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Entities;
using ImmoManager.Infrastructure.Persistence;

namespace ImmoManager.Infrastructure.Services;

/// Service de gestion des événements de biens immobiliers.
/// Permet de créer et supprimer des événements (locataire, travaux, etc.).
public class PropertyEventService : IPropertyEventService
{
    private readonly ImmoManagerDbContext _context;

    public PropertyEventService(ImmoManagerDbContext context)
    {
        _context = context;
    }

    /// Crée un nouvel événement sur un bien appartenant à l'utilisateur.
    public async Task<PropertyEventDto> CreateAsync(CreatePropertyEventRequest request, Guid userId)
    {
        var property = await _context.Properties
            .FirstOrDefaultAsync(p => p.Id == request.PropertyId && p.UserId == userId)
            ?? throw new KeyNotFoundException("Bien introuvable.");

        var evt = new PropertyEvent
        {
            PropertyId = request.PropertyId,
            UserId = userId,
            EventType = request.EventType,
            Title = request.Title,
            Description = request.Description,
            StartDate = request.StartDate,
            EndDate = request.EndDate,
            MonthlyRent = request.MonthlyRent,
            DepositAmount = request.DepositAmount,
            Cost = request.Cost,
        };

        _context.PropertyEvents.Add(evt);
        await _context.SaveChangesAsync();

        return MapToDto(evt);
    }

    /// Supprime un événement appartenant à l'utilisateur.
    public async Task<bool> DeleteAsync(Guid eventId, Guid userId)
    {
        var evt = await _context.PropertyEvents
            .FirstOrDefaultAsync(e => e.Id == eventId && e.UserId == userId);
        if (evt == null) return false;

        _context.PropertyEvents.Remove(evt);
        await _context.SaveChangesAsync();
        return true;
    }

    /// Convertit une entité PropertyEvent en DTO.
    private static PropertyEventDto MapToDto(PropertyEvent e) => new()
    {
        Id = e.Id,
        PropertyId = e.PropertyId,
        EventType = e.EventType,
        Title = e.Title,
        Description = e.Description,
        StartDate = e.StartDate,
        EndDate = e.EndDate,
        MonthlyRent = e.MonthlyRent,
        DepositAmount = e.DepositAmount,
        Cost = e.Cost,
        CreatedAt = e.CreatedAt,
    };
}
