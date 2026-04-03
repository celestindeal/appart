namespace ImmoManager.Domain.Repositories;

public interface IUnitOfWork : IDisposable
{
    IPropertyRepository Properties { get; }
    ITenantRepository Tenants { get; }
    IPurchaseRepository Purchases { get; }
    IRenovationRepository Renovations { get; }
    IAccountingRepository AccountingEntries { get; }
    IContactRepository Contacts { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
