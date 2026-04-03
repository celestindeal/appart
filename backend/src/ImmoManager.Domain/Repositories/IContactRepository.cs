using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Domain.Repositories;

public interface IContactRepository : IRepository<Contact>
{
    Task<IReadOnlyList<Contact>> GetByTypeAsync(ContactType contactType);
    Task<IReadOnlyList<Contact>> SearchAsync(string query);
}
