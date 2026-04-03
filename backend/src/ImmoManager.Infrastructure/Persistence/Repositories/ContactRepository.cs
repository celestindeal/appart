using Microsoft.EntityFrameworkCore;
using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;
using ImmoManager.Domain.Repositories;

namespace ImmoManager.Infrastructure.Persistence.Repositories;

public class ContactRepository : Repository<Contact>, IContactRepository
{
    public ContactRepository(ImmoManagerDbContext context) : base(context) { }

    public async Task<IReadOnlyList<Contact>> GetByTypeAsync(ContactType contactType)
        => await _dbSet.Where(c => c.ContactType == contactType).ToListAsync();

    public async Task<IReadOnlyList<Contact>> SearchAsync(string query)
        => await _dbSet.Where(c => c.Name.Contains(query) || (c.CompanyName != null && c.CompanyName.Contains(query))).ToListAsync();
}
