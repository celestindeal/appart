using ImmoManager.Application.DTOs.Properties;

namespace ImmoManager.Application.Services.Interfaces;

/// Interface du service de gestion des événements de biens immobiliers.
public interface IPropertyEventService
{
    /// Crée un nouvel événement sur un bien.
    Task<PropertyEventDto> CreateAsync(CreatePropertyEventRequest request, Guid userId);

    /// Supprime un événement par son ID.
    Task<bool> DeleteAsync(Guid eventId, Guid userId);
}
