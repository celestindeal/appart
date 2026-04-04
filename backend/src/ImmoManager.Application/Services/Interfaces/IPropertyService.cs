using ImmoManager.Application.DTOs.Properties;
using ImmoManager.Domain.Enums;

namespace ImmoManager.Application.Services.Interfaces;

/// Contrat du service de gestion des biens immobiliers.
public interface IPropertyService
{
    /// Récupère tous les biens d'un utilisateur, avec filtres optionnels.
    Task<List<PropertyDto>> GetAllAsync(Guid userId, string? search, PropertyType? type, PropertyStatus? status, string? city);

    /// Récupère un bien par son ID (vérifie qu'il appartient à l'utilisateur).
    Task<PropertyDto?> GetByIdAsync(Guid id, Guid userId);

    /// Crée un nouveau bien pour l'utilisateur.
    Task<PropertyDto> CreateAsync(CreatePropertyRequest request, Guid userId);

    /// Met à jour un bien existant (vérifie qu'il appartient à l'utilisateur).
    Task<PropertyDto?> UpdateAsync(Guid id, UpdatePropertyRequest request, Guid userId);

    /// Supprime un bien (vérifie qu'il appartient à l'utilisateur). Renvoie false si non trouvé.
    Task<bool> DeleteAsync(Guid id, Guid userId);
}
