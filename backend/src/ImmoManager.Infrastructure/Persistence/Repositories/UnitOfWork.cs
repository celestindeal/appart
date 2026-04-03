using ImmoManager.Domain.Repositories;

namespace ImmoManager.Infrastructure.Persistence.Repositories;

public class UnitOfWork : IUnitOfWork
{
    private readonly ImmoManagerDbContext _context;

    public IPropertyRepository Properties { get; }
    public ITenantRepository Tenants { get; }
    public IPurchaseRepository Purchases { get; }
    public IRenovationRepository Renovations { get; }
    public IAccountingRepository AccountingEntries { get; }
    public IContactRepository Contacts { get; }

    public UnitOfWork(
        ImmoManagerDbContext context,
        IPropertyRepository properties,
        ITenantRepository tenants,
        IPurchaseRepository purchases,
        IRenovationRepository renovations,
        IAccountingRepository accountingEntries,
        IContactRepository contacts)
    {
        _context = context;
        Properties = properties;
        Tenants = tenants;
        Purchases = purchases;
        Renovations = renovations;
        AccountingEntries = accountingEntries;
        Contacts = contacts;
    }

    public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        => await _context.SaveChangesAsync(cancellationToken);

    public void Dispose() => _context.Dispose();
}
