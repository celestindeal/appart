using ImmoManager.Application.DTOs.Business;

namespace ImmoManager.Application.Services.Interfaces;

public interface IBusinessService
{
    Task<List<AccountingEntryDto>> GetEntriesAsync(DateTime? from, DateTime? to, string? type, string? category, Guid? propertyId);
    Task<AccountingEntryDto> AddEntryAsync(string userId, CreateAccountingEntryRequest request);
    Task<AccountingEntryDto> UpdateEntryAsync(Guid id, CreateAccountingEntryRequest request);
    Task DeleteEntryAsync(Guid id);
    Task<FinancialSummaryDto> GetSummaryAsync(string userId);
    Task<List<ContactDto>> GetContactsAsync(string? type, string? search);
    Task<ContactDto> AddContactAsync(string userId, CreateContactRequest request);
    Task<ContactDto> UpdateContactAsync(Guid id, CreateContactRequest request);
    Task DeleteContactAsync(Guid id);
}
