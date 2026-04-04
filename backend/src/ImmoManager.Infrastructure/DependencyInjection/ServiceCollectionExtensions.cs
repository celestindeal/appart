using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Repositories;
using ImmoManager.Infrastructure.Identity;
using ImmoManager.Infrastructure.Persistence;
using ImmoManager.Infrastructure.Persistence.Repositories;
using ImmoManager.Infrastructure.Services;

namespace ImmoManager.Infrastructure.DependencyInjection;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        // Database
        services.AddDbContext<ImmoManagerDbContext>(options =>
            options.UseSqlite(configuration.GetConnectionString("DefaultConnection")));

        // Repositories
        services.AddScoped(typeof(IRepository<>), typeof(Repository<>));
        services.AddScoped<IPropertyRepository, PropertyRepository>();
        services.AddScoped<ITenantRepository, TenantRepository>();
        services.AddScoped<IPurchaseRepository, PurchaseRepository>();
        services.AddScoped<IRenovationRepository, RenovationRepository>();
        services.AddScoped<IAccountingRepository, AccountingRepository>();
        services.AddScoped<IContactRepository, ContactRepository>();
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        // Services métier
        services.AddScoped<IPropertyService, PropertyService>();

        // Identity / Auth
        services.Configure<JwtSettings>(configuration.GetSection("JwtSettings"));
        services.AddScoped<IAuthService, AuthService>();

        return services;
    }
}
