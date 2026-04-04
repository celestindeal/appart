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
public class PropertyService : IPropertyService
{
    private readonly ImmoManagerDbContext _context;

    public PropertyService(ImmoManagerDbContext context)
    {
        _context = context;
    }

    /// Récupère tous les biens de l'utilisateur, avec filtres optionnels
    /// sur le texte de recherche, le type, le statut et la ville.
    public async Task<List<PropertyDto>> GetAllAsync(
        Guid userId, string? search, PropertyType? type, PropertyStatus? status, string? city)
    {
        var query = _context.Properties.Where(p => p.UserId == userId);

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

    /// Récupère un bien par son ID. Renvoie null s'il n'appartient pas à l'utilisateur.
    public async Task<PropertyDto?> GetByIdAsync(Guid id, Guid userId)
    {
        var property = await _context.Properties
            .FirstOrDefaultAsync(p => p.Id == id && p.UserId == userId);

        return property == null ? null : MapToDto(property);
    }

    /// Crée un nouveau bien en base pour l'utilisateur donné.
    public async Task<PropertyDto> CreateAsync(CreatePropertyRequest request, Guid userId)
    {
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
            MonthlyRent = request.MonthlyRent,
            PropertyTax = request.PropertyTax,
            Insurance = request.Insurance,
            MonthlyCharges = request.MonthlyCharges,
            IsRented = request.IsRented,
            Status = request.Status,
            ApartmentCount = request.PropertyType == PropertyType.Building ? request.ApartmentCount : null,
        };

        _context.Properties.Add(property);
        await _context.SaveChangesAsync();

        return MapToDto(property);
    }

    /// Met à jour un bien existant. Renvoie null s'il n'appartient pas à l'utilisateur.
    public async Task<PropertyDto?> UpdateAsync(Guid id, UpdatePropertyRequest request, Guid userId)
    {
        var property = await _context.Properties
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
        property.MonthlyRent = request.MonthlyRent;
        property.PropertyTax = request.PropertyTax;
        property.Insurance = request.Insurance;
        property.MonthlyCharges = request.MonthlyCharges;
        property.IsRented = request.IsRented;
        property.Status = request.Status;
        property.ApartmentCount = request.PropertyType == PropertyType.Building ? request.ApartmentCount : null;

        await _context.SaveChangesAsync();

        return MapToDto(property);
    }

    /// Supprime un bien. Renvoie false s'il n'appartient pas à l'utilisateur.
    public async Task<bool> DeleteAsync(Guid id, Guid userId)
    {
        var property = await _context.Properties
            .FirstOrDefaultAsync(p => p.Id == id && p.UserId == userId);

        if (property == null) return false;

        _context.Properties.Remove(property);
        await _context.SaveChangesAsync();

        return true;
    }

    /// Convertit une entité Property en DTO pour la réponse API.
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
        MonthlyRent = p.MonthlyRent,
        PropertyTax = p.PropertyTax,
        Insurance = p.Insurance,
        MonthlyCharges = p.MonthlyCharges,
        IsRented = p.IsRented,
        Status = p.Status,
        ApartmentCount = p.ApartmentCount,
        CreatedAt = p.CreatedAt,
        UpdatedAt = p.UpdatedAt,
    };
}
