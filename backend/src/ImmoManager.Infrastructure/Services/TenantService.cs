using Microsoft.EntityFrameworkCore;
using ImmoManager.Application.DTOs.Tenants;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Entities;
using ImmoManager.Infrastructure.Persistence;

namespace ImmoManager.Infrastructure.Services;

/// Service de gestion des locataires.
/// L'ownership se fait via le bien parent (Tenant.Property.UserId) :
/// un utilisateur ne peut accéder qu'aux locataires de ses propres biens.
public class TenantService : ITenantService
{
    private readonly ImmoManagerDbContext _context;

    public TenantService(ImmoManagerDbContext context)
    {
        _context = context;
    }

    public async Task<List<TenantDto>> GetAllAsync(Guid userId)
    {
        var tenants = await _context.Tenants
            .Include(t => t.Property)
            .Where(t => t.Property.UserId == userId)
            .OrderByDescending(t => t.CreatedAt)
            .ToListAsync();

        return tenants.Select(MapToDto).ToList();
    }

    public async Task<TenantDto?> GetByIdAsync(Guid id, Guid userId)
    {
        var tenant = await _context.Tenants
            .Include(t => t.Property)
            .FirstOrDefaultAsync(t => t.Id == id && t.Property.UserId == userId);

        return tenant == null ? null : MapToDto(tenant);
    }

    public async Task<TenantDto> CreateAsync(CreateTenantRequest request, Guid userId)
    {
        var property = await _context.Properties
            .FirstOrDefaultAsync(p => p.Id == request.PropertyId && p.UserId == userId);

        if (property == null)
            throw new ArgumentException("Le bien associé n'existe pas ou ne vous appartient pas.");

        var tenant = new Tenant
        {
            PropertyId = request.PropertyId,
            FirstName = request.FirstName,
            LastName = request.LastName,
            Email = request.Email ?? string.Empty,
            PhoneNumber = request.PhoneNumber,
            IdentityDocumentType = request.IdentityDocumentType,
            IdentityDocumentNumber = request.IdentityDocumentNumber,
            MoveInDate = request.MoveInDate,
            MoveOutDate = request.MoveOutDate,
            MonthlyRent = request.MonthlyRent,
            DepositAmount = request.DepositAmount,
            Status = request.Status,
        };

        _context.Tenants.Add(tenant);
        await _context.SaveChangesAsync();

        tenant.Property = property;
        return MapToDto(tenant);
    }

    public async Task<TenantDto?> UpdateAsync(Guid id, UpdateTenantRequest request, Guid userId)
    {
        var tenant = await _context.Tenants
            .Include(t => t.Property)
            .FirstOrDefaultAsync(t => t.Id == id && t.Property.UserId == userId);

        if (tenant == null) return null;

        tenant.FirstName = request.FirstName;
        tenant.LastName = request.LastName;
        tenant.Email = request.Email ?? string.Empty;
        tenant.PhoneNumber = request.PhoneNumber;
        tenant.IdentityDocumentType = request.IdentityDocumentType;
        tenant.IdentityDocumentNumber = request.IdentityDocumentNumber;
        tenant.MoveInDate = request.MoveInDate;
        tenant.MoveOutDate = request.MoveOutDate;
        tenant.MonthlyRent = request.MonthlyRent;
        tenant.DepositAmount = request.DepositAmount;
        tenant.DepositReturnedDate = request.DepositReturnedDate;
        tenant.Status = request.Status;

        await _context.SaveChangesAsync();

        return MapToDto(tenant);
    }

    public async Task<bool> DeleteAsync(Guid id, Guid userId)
    {
        var tenant = await _context.Tenants
            .Include(t => t.Property)
            .FirstOrDefaultAsync(t => t.Id == id && t.Property.UserId == userId);

        if (tenant == null) return false;

        _context.Tenants.Remove(tenant);
        await _context.SaveChangesAsync();

        return true;
    }

    private static TenantDto MapToDto(Tenant t) => new()
    {
        Id = t.Id,
        PropertyId = t.PropertyId,
        PropertyName = t.Property?.Name ?? string.Empty,
        FirstName = t.FirstName,
        LastName = t.LastName,
        Email = t.Email,
        PhoneNumber = t.PhoneNumber,
        IdentityDocumentType = t.IdentityDocumentType,
        IdentityDocumentNumber = t.IdentityDocumentNumber,
        MoveInDate = t.MoveInDate,
        MoveOutDate = t.MoveOutDate,
        MonthlyRent = t.MonthlyRent,
        DepositAmount = t.DepositAmount,
        DepositReturnedDate = t.DepositReturnedDate,
        Status = t.Status,
        CreatedAt = t.CreatedAt,
        UpdatedAt = t.UpdatedAt,
    };
}
