import '../models/property_event_model.dart';
import '../models/property_model.dart';

/// Contrat de la source de donnees distante pour les biens immobiliers.
abstract class PropertyRemoteDatasource {
  /// Recupere la liste de tous les biens.
  Future<List<PropertyModel>> getProperties();

  /// Recupere un bien par son identifiant.
  Future<PropertyModel> getPropertyById(String id);

  /// Cree un nouveau bien.
  Future<PropertyModel> createProperty(PropertyModel model);

  /// Met a jour un bien existant.
  Future<PropertyModel> updateProperty(PropertyModel model);

  /// Supprime un bien par son identifiant.
  Future<void> deleteProperty(String id);

  /// Recherche des biens avec des filtres.
  Future<List<PropertyModel>> searchProperties({
    String? query,
    String? propertyType,
    String? status,
    double? minPrice,
    double? maxPrice,
    double? minSurface,
    double? maxSurface,
    String? city,
    bool? isRented,
  });

  /// Cree un nouvel evenement attache a un bien.
  Future<PropertyEventModel> createPropertyEvent(PropertyEventModel event);

  /// Supprime un evenement par son identifiant.
  Future<void> deletePropertyEvent(String eventId);
}
