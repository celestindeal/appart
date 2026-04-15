using Microsoft.EntityFrameworkCore;
using ImmoManager.Application.DTOs.Tenants;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Entities;
using ImmoManager.Infrastructure.Persistence;

namespace ImmoManager.Infrastructure.Services;

public class PaymentService : IPaymentService
{
    private readonly ImmoManagerDbContext _context;

    public PaymentService(ImmoManagerDbContext context)
    {
        _context = context;
    }

    public async Task<List<RentPaymentDto>> GetByTenantAsync(Guid tenantId, Guid userId)
    {
        var payments = await _context.RentPayments
            .Include(p => p.Property)
            .Where(p => p.TenantId == tenantId && p.Property.UserId == userId)
            .OrderByDescending(p => p.PaymentDueDate)
            .ToListAsync();

        return payments.Select(MapToDto).ToList();
    }

    public async Task<RentPaymentDto?> GetByIdAsync(Guid id, Guid userId)
    {
        var payment = await _context.RentPayments
            .Include(p => p.Property)
            .FirstOrDefaultAsync(p => p.Id == id && p.Property.UserId == userId);

        return payment == null ? null : MapToDto(payment);
    }

    public async Task<RentPaymentDto> CreateAsync(CreatePaymentRequest request, Guid userId)
    {
        // Vérifie que le tenant appartient bien au user via la propriété.
        var tenant = await _context.Tenants
            .Include(t => t.Property)
            .FirstOrDefaultAsync(t => t.Id == request.TenantId && t.Property.UserId == userId);

        if (tenant == null)
            throw new ArgumentException("Le locataire n'existe pas.");

        if (tenant.PropertyId != request.PropertyId)
            throw new ArgumentException("Le bien ne correspond pas au locataire.");

        var payment = new RentPayment
        {
            TenantId = request.TenantId,
            PropertyId = request.PropertyId,
            Amount = request.Amount,
            PaymentDueDate = request.PaymentDueDate,
            PaymentDate = request.PaymentDate,
            PaymentMethod = request.PaymentMethod,
            Status = request.Status,
            Notes = request.Notes,
        };

        _context.RentPayments.Add(payment);
        await _context.SaveChangesAsync();

        return MapToDto(payment);
    }

    public async Task<RentPaymentDto?> UpdateAsync(Guid id, UpdatePaymentRequest request, Guid userId)
    {
        var payment = await _context.RentPayments
            .Include(p => p.Property)
            .FirstOrDefaultAsync(p => p.Id == id && p.Property.UserId == userId);

        if (payment == null) return null;

        payment.Amount = request.Amount;
        payment.PaymentDueDate = request.PaymentDueDate;
        payment.PaymentDate = request.PaymentDate;
        payment.PaymentMethod = request.PaymentMethod;
        payment.Status = request.Status;
        payment.Notes = request.Notes;

        await _context.SaveChangesAsync();

        return MapToDto(payment);
    }

    public async Task<bool> DeleteAsync(Guid id, Guid userId)
    {
        var payment = await _context.RentPayments
            .Include(p => p.Property)
            .FirstOrDefaultAsync(p => p.Id == id && p.Property.UserId == userId);

        if (payment == null) return false;

        _context.RentPayments.Remove(payment);
        await _context.SaveChangesAsync();

        return true;
    }

    private static RentPaymentDto MapToDto(RentPayment p) => new()
    {
        Id = p.Id,
        TenantId = p.TenantId,
        PropertyId = p.PropertyId,
        Amount = p.Amount,
        PaymentDueDate = p.PaymentDueDate,
        PaymentDate = p.PaymentDate,
        PaymentMethod = p.PaymentMethod,
        Status = p.Status,
        Notes = p.Notes,
        CreatedAt = p.CreatedAt,
        UpdatedAt = p.UpdatedAt,
    };
}
