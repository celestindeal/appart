using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ImmoManager.Domain.Entities;

namespace ImmoManager.Infrastructure.Persistence.Configurations;

public class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Email).HasMaxLength(256).IsRequired();
        builder.HasIndex(e => e.Email).IsUnique();
        builder.Property(e => e.FirstName).HasMaxLength(100).IsRequired();
        builder.Property(e => e.LastName).HasMaxLength(100).IsRequired();
        builder.Property(e => e.PasswordHash).IsRequired();
    }
}

public class PropertyConfiguration : IEntityTypeConfiguration<Property>
{
    public void Configure(EntityTypeBuilder<Property> builder)
    {
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Name).HasMaxLength(255).IsRequired();
        builder.Property(e => e.Address).HasMaxLength(500).IsRequired();
        builder.Property(e => e.PostalCode).HasMaxLength(20).IsRequired();
        builder.Property(e => e.City).HasMaxLength(100).IsRequired();
        builder.Property(e => e.Country).HasMaxLength(100).IsRequired();
        builder.HasIndex(e => e.UserId);
        builder.HasIndex(e => e.City);
        builder.HasOne(e => e.User).WithMany(u => u.Properties).HasForeignKey(e => e.UserId);
        builder.HasOne(e => e.PurchaseProject).WithOne(p => p.Property).HasForeignKey<PurchaseProject>(p => p.PropertyId);
    }
}

public class TenantConfiguration : IEntityTypeConfiguration<Tenant>
{
    public void Configure(EntityTypeBuilder<Tenant> builder)
    {
        builder.HasKey(e => e.Id);
        builder.Property(e => e.FirstName).HasMaxLength(100).IsRequired();
        builder.Property(e => e.LastName).HasMaxLength(100).IsRequired();
        builder.HasIndex(e => e.PropertyId);
        builder.HasOne(e => e.Property).WithMany(p => p.Tenants).HasForeignKey(e => e.PropertyId);
    }
}

public class RenovationProjectConfiguration : IEntityTypeConfiguration<RenovationProject>
{
    public void Configure(EntityTypeBuilder<RenovationProject> builder)
    {
        builder.HasKey(e => e.Id);
        builder.Property(e => e.ProjectName).HasMaxLength(255).IsRequired();
        builder.HasIndex(e => e.PropertyId);
        builder.HasOne(e => e.Property).WithMany(p => p.RenovationProjects).HasForeignKey(e => e.PropertyId);
    }
}

public class AccountingEntryConfiguration : IEntityTypeConfiguration<AccountingEntry>
{
    public void Configure(EntityTypeBuilder<AccountingEntry> builder)
    {
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Description).HasMaxLength(500);
        builder.HasIndex(e => e.UserId);
        builder.HasIndex(e => e.EntryDate);
        builder.HasOne(e => e.User).WithMany().HasForeignKey(e => e.UserId);
        builder.HasOne(e => e.Property).WithMany().HasForeignKey(e => e.PropertyId).IsRequired(false);
    }
}

public class ContactConfiguration : IEntityTypeConfiguration<Contact>
{
    public void Configure(EntityTypeBuilder<Contact> builder)
    {
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Name).HasMaxLength(255).IsRequired();
        builder.Property(e => e.Email).HasMaxLength(256);
        builder.HasIndex(e => e.UserId);
        builder.HasOne(e => e.User).WithMany().HasForeignKey(e => e.UserId);
    }
}
