using ImmoManager.Application.DTOs.Loans;

namespace ImmoManager.Application.Services.Interfaces;

public interface ILoanService
{
    Task<List<LoanDto>> GetByPropertyAsync(Guid propertyId, Guid userId);
    Task<LoanDto?> GetByIdAsync(Guid id, Guid userId);
    Task<LoanDto> CreateAsync(CreateLoanRequest request, Guid userId);
    Task<LoanDto?> UpdateAsync(Guid id, UpdateLoanRequest request, Guid userId);
    Task<bool> DeleteAsync(Guid id, Guid userId);
}
