using Microsoft.EntityFrameworkCore;
using ImmoManager.Application.DTOs.Loans;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Entities;
using ImmoManager.Infrastructure.Persistence;

namespace ImmoManager.Infrastructure.Services;

public class LoanService : ILoanService
{
    private readonly ImmoManagerDbContext _context;

    public LoanService(ImmoManagerDbContext context)
    {
        _context = context;
    }

    public async Task<List<LoanDto>> GetByPropertyAsync(Guid propertyId, Guid userId)
    {
        var loans = await _context.Loans
            .Include(l => l.Property)
            .Where(l => l.PropertyId == propertyId && l.Property.UserId == userId)
            .OrderByDescending(l => l.StartDate)
            .ToListAsync();

        return loans.Select(MapToDto).ToList();
    }

    public async Task<LoanDto?> GetByIdAsync(Guid id, Guid userId)
    {
        var loan = await _context.Loans
            .Include(l => l.Property)
            .FirstOrDefaultAsync(l => l.Id == id && l.Property.UserId == userId);

        return loan == null ? null : MapToDto(loan);
    }

    public async Task<LoanDto> CreateAsync(CreateLoanRequest request, Guid userId)
    {
        var property = await _context.Properties
            .FirstOrDefaultAsync(p => p.Id == request.PropertyId && p.UserId == userId);

        if (property == null)
            throw new ArgumentException("Le bien n'existe pas.");

        var loan = new Loan
        {
            PropertyId = request.PropertyId,
            Name = request.Name,
            BankName = request.BankName,
            Amount = request.Amount,
            InterestRate = request.InterestRate,
            DurationMonths = request.DurationMonths,
            StartDate = request.StartDate,
            DeferralMonths = request.DeferralMonths,
            DeferralType = request.DeferralType,
            MonthlyPayment = request.MonthlyPayment,
        };

        _context.Loans.Add(loan);
        await _context.SaveChangesAsync();

        return MapToDto(loan);
    }

    public async Task<LoanDto?> UpdateAsync(Guid id, UpdateLoanRequest request, Guid userId)
    {
        var loan = await _context.Loans
            .Include(l => l.Property)
            .FirstOrDefaultAsync(l => l.Id == id && l.Property.UserId == userId);

        if (loan == null) return null;

        loan.Name = request.Name;
        loan.BankName = request.BankName;
        loan.Amount = request.Amount;
        loan.InterestRate = request.InterestRate;
        loan.DurationMonths = request.DurationMonths;
        loan.StartDate = request.StartDate;
        loan.DeferralMonths = request.DeferralMonths;
        loan.DeferralType = request.DeferralType;
        loan.MonthlyPayment = request.MonthlyPayment;

        await _context.SaveChangesAsync();

        return MapToDto(loan);
    }

    public async Task<bool> DeleteAsync(Guid id, Guid userId)
    {
        var loan = await _context.Loans
            .Include(l => l.Property)
            .FirstOrDefaultAsync(l => l.Id == id && l.Property.UserId == userId);

        if (loan == null) return false;

        _context.Loans.Remove(loan);
        await _context.SaveChangesAsync();

        return true;
    }

    private static LoanDto MapToDto(Loan l) => new()
    {
        Id = l.Id,
        PropertyId = l.PropertyId,
        Name = l.Name,
        BankName = l.BankName,
        Amount = l.Amount,
        InterestRate = l.InterestRate,
        DurationMonths = l.DurationMonths,
        StartDate = l.StartDate,
        DeferralMonths = l.DeferralMonths,
        DeferralType = l.DeferralType,
        MonthlyPayment = l.MonthlyPayment,
        CreatedAt = l.CreatedAt,
        UpdatedAt = l.UpdatedAt,
    };
}
