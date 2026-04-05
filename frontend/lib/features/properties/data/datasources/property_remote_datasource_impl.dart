import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/property_event_model.dart';
import '../models/property_model.dart';
import 'property_remote_datasource.dart';

/// Implémentation des appels API pour les biens immobiliers via Dio.
class PropertyRemoteDatasourceImpl implements PropertyRemoteDatasource {
  final Dio _dio;

  PropertyRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  /// GET /api/properties — Récupère tous les biens de l'utilisateur connecté.
  @override
  Future<List<PropertyModel>> getProperties() async {
    final response = await _dio.get(ApiEndpoints.properties);
    final list = response.data as List<dynamic>;
    return list
        .map((json) => PropertyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/properties/{id} — Récupère un bien par son ID.
  @override
  Future<PropertyModel> getPropertyById(String id) async {
    final response = await _dio.get(ApiEndpoints.propertyById(id));
    return PropertyModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /api/properties — Crée un nouveau bien.
  @override
  Future<PropertyModel> createProperty(PropertyModel model) async {
    final response = await _dio.post(
      ApiEndpoints.properties,
      data: model.toJson(),
    );
    return PropertyModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// PUT /api/properties/{id} — Met à jour un bien existant.
  @override
  Future<PropertyModel> updateProperty(PropertyModel model) async {
    final response = await _dio.put(
      ApiEndpoints.propertyById(model.id),
      data: model.toJson(),
    );
    return PropertyModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// DELETE /api/properties/{id} — Supprime un bien.
  @override
  Future<void> deleteProperty(String id) async {
    await _dio.delete(ApiEndpoints.propertyById(id));
  }

  /// GET /api/properties?search=...&type=...&status=...&city=... — Recherche avec filtres.
  @override
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
  }) async {
    final queryParams = <String, dynamic>{};
    if (query != null && query.isNotEmpty) queryParams['search'] = query;
    if (propertyType != null) queryParams['type'] = propertyType;
    if (status != null) queryParams['status'] = status;
    if (city != null && city.isNotEmpty) queryParams['city'] = city;

    final response = await _dio.get(
      ApiEndpoints.properties,
      queryParameters: queryParams,
    );
    final list = response.data as List<dynamic>;
    return list
        .map((json) => PropertyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/PropertyEvents — Crée un événement attaché à un bien.
  @override
  Future<PropertyEventModel> createPropertyEvent(
    PropertyEventModel event,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.propertyEvents,
      data: event.toJson(),
    );
    return PropertyEventModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// DELETE /api/PropertyEvents/{id} — Supprime un événement.
  @override
  Future<void> deletePropertyEvent(String eventId) async {
    await _dio.delete(ApiEndpoints.propertyEventById(eventId));
  }
}
