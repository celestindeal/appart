using ImmoManager.Domain.Common;

namespace ImmoManager.Domain.Entities;

/// Emprunt bancaire associe a un bien immobilier.
public class Loan : BaseEntity
{
    public Guid PropertyId { get; set; }

    /// Nom ou libelle de l'emprunt (ex : "Pret principal", "Pret travaux").
    public string Name { get; set; } = string.Empty;

    /// Nom de la banque.
    public string? BankName { get; set; }

    /// Montant total emprunte (euros).
    public decimal Amount { get; set; }

    /// Taux d'interet annuel (ex : 3.5 pour 3,5 %).
    public decimal InterestRate { get; set; }

    /// Duree totale de l'emprunt en mois.
    public int DurationMonths { get; set; }

    /// Date de debut de l'emprunt.
    public DateTime StartDate { get; set; }

    /// Duree du differe en mois (0 si pas de differe).
    public int DeferralMonths { get; set; }

    /// Type de differe : "total" ou "partial" (null si pas de differe).
    public string? DeferralType { get; set; }

    /// Mensualite de remboursement saisie manuellement (euros).
    public decimal MonthlyPayment { get; set; }

    // Navigation
    public Property Property { get; set; } = null!;
}
