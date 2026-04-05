using Microsoft.EntityFrameworkCore;
using ImmoManager.Application.DTOs.Properties;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;
using ImmoManager.Infrastructure.Persistence;

namespace ImmoManager.Infrastructure.Services;

/// Service de gestion des biens immobiliers.
/// Gère le CRUD des biens en s'assurant que chaque utilisateur
/// ne peut accéder qu'à ses propres biens.
/// Les biens "racine" (sans parent) sont affichés dans la liste principale.
/// Les appartements d'un immeuble sont chargés via la relation parent-enfant.
public class PropertyService : IPropertyService
{
    private readonly ImmoManagerDbContext _context;

    public PropertyService(ImmoManagerDbContext context)
    {
        _context = context;
    }

    /// Récupère tous les biens racine de l'utilisateur (exclut les appartements enfants).
    /// Inclut la liste des appartements pour les immeubles.
    public async Task<List<PropertyDto>> GetAllAsync(
        Guid userId, string? search, PropertyType? type, PropertyStatus? status, string? city)
    {
        var query = _context.Properties
            .Include(p => p.Apartments)
                .ThenInclude(a => a.Events)
            .Include(p => p.Events)
            .Where(p => p.UserId == userId && p.ParentPropertyId == null);

        if (!string.IsNullOrWhiteSpace(search))
        {
            var s = search.ToLower();
            query = query.Where(p =>
                p.Name.ToLower().Contains(s) ||
                p.Address.ToLower().Contains(s) ||
                p.City.ToLower().Contains(s));
        }

        if (type.HasValue)
            query = query.Where(p => p.PropertyType == type.Value);

        if (status.HasValue)
            query = query.Where(p => p.Status == status.Value);

        if (!string.IsNullOrWhiteSpace(city))
            query = query.Where(p => p.City.ToLower() == city.ToLower());

        var properties = await query.OrderByDescending(p => p.CreatedAt).ToListAsync();
        return properties.Select(MapToDto).ToList();
    }

    /// Récupère un bien par son ID, avec ses appartements s'il s'agit d'un immeuble.
    /// Renvoie null s'il n'appartient pas à l'utilisateur.
    public async Task<PropertyDto?> GetByIdAsync(Guid id, Guid userId)
    {
        var property = await _context.Properties
            .Include(p => p.Apartments)
                .ThenInclude(a => a.Events)
            .Include(p => p.Events)
            .FirstOrDefaultAsync(p => p.Id == id && p.UserId == userId);

        return property == null ? null : MapToDto(property);
    }

    /// Crée un nouveau bien en base pour l'utilisateur donné.
    /// Si ParentPropertyId est spécifié, vérifie que le parent existe,
    /// appartient à l'utilisateur et est de type Building.
    public async Task<PropertyDto> CreateAsync(CreatePropertyRequest request, Guid userId)
    {
        if (request.ParentPropertyId.HasValue)
        {
            var parent = await _context.Properties
                .FirstOrDefaultAsync(p => p.Id == request.ParentPropertyId.Value && p.UserId == userId);

            if (parent == null)
                throw new ArgumentException("L'immeuble parent n'existe pas.");

            if (parent.PropertyType != PropertyType.Building)
                throw new ArgumentException("Le bien parent doit être un immeuble.");
        }

        var property = new Property
        {
            UserId = userId,
            Name = request.Name,
            Description = request.Description,
            Address = request.Address,
            PostalCode = request.PostalCode,
            City = request.City,
            Country = request.Country,
            PropertyType = request.PropertyType,
            AcquisitionDate = request.AcquisitionDate,
            AcquisitionPrice = request.AcquisitionPrice,
            CurrentValue = request.CurrentValue,
            Surface = request.Surface,
            RoomCount = request.RoomCount,
            BathroomCount = request.BathroomCount,
            ParkingSpaces = request.ParkingSpaces,
            PropertyTax = request.PropertyTax,
            Insurance = request.Insurance,
            MonthlyCharges = request.MonthlyCharges,
            IsRented = request.IsRented,
            Status = request.Status,
            ParentPropertyId = request.ParentPropertyId,
        };

        _context.Properties.Add(property);
        await _context.SaveChangesAsync();

        return MapToDto(property);
    }

    /// Met à jour un bien existant. Renvoie null s'il n'appartient pas à l'utilisateur.
    public async Task<PropertyDto?> UpdateAsync(Guid id, UpdatePropertyRequest request, Guid userId)
    {
        var property = await _context.Properties
            .Include(p => p.Apartments)
                .ThenInclude(a => a.Events)
            .Include(p => p.Events)
            .FirstOrDefaultAsync(p => p.Id == id && p.UserId == userId);

        if (property == null) return null;

        property.Name = request.Name;
        property.Description = request.Description;
        property.Address = request.Address;
        property.PostalCode = request.PostalCode;
        property.City = request.City;
        property.Country = request.Country;
        property.PropertyType = request.PropertyType;
        property.AcquisitionDate = request.AcquisitionDate;
        property.AcquisitionPrice = request.AcquisitionPrice;
        property.CurrentValue = request.CurrentValue;
        property.Surface = request.Surface;
        property.RoomCount = request.RoomCount;
        property.BathroomCount = request.BathroomCount;
        property.ParkingSpaces = request.ParkingSpaces;
        property.PropertyTax = request.PropertyTax;
        property.Insurance = request.Insurance;
        property.MonthlyCharges = request.MonthlyCharges;
        property.IsRented = request.IsRented;
        property.Status = request.Status;
        property.ParentPropertyId = request.ParentPropertyId;

        await _context.SaveChangesAsync();

        return MapToDto(property);
    }

    /// Supprime un bien (et ses appartements enfants en cascade).
    /// Renvoie false s'il n'appartient pas à l'utilisateur.
    public async Task<bool> DeleteAsync(Guid id, Guid userId)
    {
        var property = await _context.Properties
            .FirstOrDefaultAsync(p => p.Id == id && p.UserId == userId);

        if (property == null) return false;

        _context.Properties.Remove(property);
        await _context.SaveChangesAsync();

        return true;
    }

    /// Convertit une entité Property en DTO, avec ses appartements enfants.
    private static PropertyDto MapToDto(Property p) => new()
    {
        Id = p.Id,
        UserId = p.UserId,
        Name = p.Name,
        Description = p.Description,
        Address = p.Address,
        PostalCode = p.PostalCode,
        City = p.City,
        Country = p.Country,
        PropertyType = p.PropertyType,
        AcquisitionDate = p.AcquisitionDate,
        AcquisitionPrice = p.AcquisitionPrice,
        CurrentValue = p.CurrentValue,
        Surface = p.Surface,
        RoomCount = p.RoomCount,
        BathroomCount = p.BathroomCount,
        ParkingSpaces = p.ParkingSpaces,
        PropertyTax = p.PropertyTax,
        Insurance = p.Insurance,
        MonthlyCharges = p.MonthlyCharges,
        IsRented = p.IsRented,
        Status = p.Status,
        ParentPropertyId = p.ParentPropertyId,
        Apartments = p.Apartments?.Select(MapToDto).ToList(),
        Events = p.Events?.Select(e => new PropertyEventDto
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
        }).ToList(),
        CreatedAt = p.CreatedAt,
        UpdatedAt = p.UpdatedAt,
    };
}
