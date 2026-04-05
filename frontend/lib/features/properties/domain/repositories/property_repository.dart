import '../entities/profitability_result.dart';
import '../entities/property_entity.dart';
import '../entities/property_event_entity.dart';

/// Contrat du repository pour la gestion des biens immobiliers.
abstract class PropertyRepository {
  /// Recupere la liste de tous les biens de l'utilisateur.
  Future<List<PropertyEntity>> getProperties();

  /// Recupere un bien par son identifiant.
  Future<PropertyEntity> getPropertyById(String id);

  /// Cree un nouveau bien.
  Future<PropertyEntity> createProperty(PropertyEntity property);

  /// Met a jour un bien existant.
  Future<PropertyEntity> updateProperty(PropertyEntity property);

  /// Supprime un bien par son identifiant.
  Future<void> deleteProperty(String id);

  /// Recherche des biens avec des filtres optionnels.
  Future<List<PropertyEntity>> searchProperties({
    String? query,
    PropertyType? propertyType,
    PropertyStatus? status,
    double? minPrice,
    double? maxPrice,
    double? minSurface,
    double? maxSurface,
    String? city,
    bool? isRented,
  });

  /// Calcule la rentabilite d'un investissement immobilier.
  Future<ProfitabilityResult> calculateProfitability({
    required double price,
    required double monthlyRent,
    double charges = 0,
    double propertyTax = 0,
    double insurance = 0,
    double loanRate = 0,
    int loanDuration = 20,
    double downPayment = 0,
    double renovationCost = 0,
    double notaryFeesPercent = 7.5,
    double surface = 0,
  });

  /// Cree un nouvel evenement (locataire, travaux, autre) attache a un bien.
  Future<PropertyEventEntity> createPropertyEvent(PropertyEventEntity event);

  /// Supprime un evenement par son identifiant.
  Future<void> deletePropertyEvent(String eventId);
}
