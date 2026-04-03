using Microsoft.EntityFrameworkCore;
using ImmoManager.Domain.Entities;

namespace ImmoManager.Infrastructure.Persistence;

public class ImmoManagerDbContext : DbContext
{
    public ImmoManagerDbContext(DbContextOptions<ImmoManagerDbContext> options) : base(options) { }

    public DbSet<User> Users => Set<User>();
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();
    public DbSet<Property> Properties => Set<Property>();
    public DbSet<PropertyDocument> PropertyDocuments => Set<PropertyDocument>();
    public DbSet<PurchaseProject> PurchaseProjects => Set<PurchaseProject>();
    public DbSet<PurchaseMilestone> PurchaseMilestones => Set<PurchaseMilestone>();
    public DbSet<RenovationProject> RenovationProjects => Set<RenovationProject>();
    public DbSet<RenovationTask> RenovationTasks => Set<RenovationTask>();
    public DbSet<BudgetItem> BudgetItems => Set<BudgetItem>();
    public DbSet<Tenant> Tenants => Set<Tenant>();
    public DbSet<TenantDocument> TenantDocuments => Set<TenantDocument>();
    public DbSet<RentPayment> RentPayments => Set<RentPayment>();
    public DbSet<Reminder> Reminders => Set<Reminder>();
    public DbSet<PropertyExpense> PropertyExpenses => Set<PropertyExpense>();
    public DbSet<AccountingEntry> AccountingEntries => Set<AccountingEntry>();
    public DbSet<Contact> Contacts => Set<Contact>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ImmoManagerDbContext).Assembly);
    }

    public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        foreach (var entry in ChangeTracker.Entries<Domain.Common.BaseEntity>())
        {
            if (entry.State == EntityState.Modified)
                entry.Entity.UpdatedAt = DateTime.UtcNow;
        }
        return base.SaveChangesAsync(cancellationToken);
    }
}
