namespace ImmoManager.Domain.Enums;

/// Types d'événements associés à un bien immobilier.
public enum PropertyEventType
{
    /// Événement de type locataire (entrée/sortie, loyer).
    Tenant,

    /// Événement de type travaux (rénovation, réparation).
    Renovation,

    /// Autre événement (divers).
    Other
}
