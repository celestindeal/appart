import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';

/// Etat de la recherche de biens.
class PropertySearchState {
  const PropertySearchState({
    this.query = '',
    this.propertyType,
    this.status,
    this.minPrice,
    this.maxPrice,
    this.minSurface,
    this.maxSurface,
    this.city,
    this.isRented,
  });

  final String query;
  final PropertyType? propertyType;
  final PropertyStatus? status;
  final double? minPrice;
  final double? maxPrice;
  final double? minSurface;
  final double? maxSurface;
  final String? city;
  final bool? isRented;

  PropertySearchState copyWith({
    String? query,
    PropertyType? propertyType,
    PropertyStatus? status,
    double? minPrice,
    double? maxPrice,
    double? minSurface,
    double? maxSurface,
    String? city,
    bool? isRented,
    bool clearPropertyType = false,
    bool clearStatus = false,
    bool clearCity = false,
    bool clearIsRented = false,
  }) {
    return PropertySearchState(
      query: query ?? this.query,
      propertyType: clearPropertyType ? null : (propertyType ?? this.propertyType),
      status: clearStatus ? null : (status ?? this.status),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minSurface: minSurface ?? this.minSurface,
      maxSurface: maxSurface ?? this.maxSurface,
      city: clearCity ? null : (city ?? this.city),
      isRented: clearIsRented ? null : (isRented ?? this.isRented),
    );
  }

  bool get hasActiveFilters =>
      propertyType != null ||
      status != null ||
      minPrice != null ||
      maxPrice != null ||
      minSurface != null ||
      maxSurface != null ||
      city != null ||
      isRented != null;
}

/// Provider du repository (a overrider dans le main avec l'implementation concrete).
final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  throw UnimplementedError(
    'propertyRepositoryProvider doit etre override avec une implementation concrete.',
  );
});

/// Provider de l'etat de recherche.
final propertySearchProvider =
    StateNotifierProvider<PropertySearchNotifier, PropertySearchState>((ref) {
  return PropertySearchNotifier();
});

/// Notifier pour gerer l'etat de la recherche.
class PropertySearchNotifier extends StateNotifier<PropertySearchState> {
  PropertySearchNotifier() : super(const PropertySearchState());

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void updatePropertyType(PropertyType? type) {
    state = type == null
        ? state.copyWith(clearPropertyType: true)
        : state.copyWith(propertyType: type);
  }

  void updateStatus(PropertyStatus? status) {
    state = status == null
        ? state.copyWith(clearStatus: true)
        : state.copyWith(status: status);
  }

  void updateCity(String? city) {
    state = city == null || city.isEmpty
        ? state.copyWith(clearCity: true)
        : state.copyWith(city: city);
  }

  void updatePriceRange({double? min, double? max}) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void updateSurfaceRange({double? min, double? max}) {
    state = state.copyWith(minSurface: min, maxSurface: max);
  }

  void updateIsRented(bool? isRented) {
    state = isRented == null
        ? state.copyWith(clearIsRented: true)
        : state.copyWith(isRented: isRented);
  }

  void clearFilters() {
    state = PropertySearchState(query: state.query);
  }

  void clearAll() {
    state = const PropertySearchState();
  }
}

/// Provider de la liste des biens (avec recherche et filtres).
final propertiesListProvider =
    FutureProvider.autoDispose<List<PropertyEntity>>((ref) async {
  final repository = ref.watch(propertyRepositoryProvider);
  final search = ref.watch(propertySearchProvider);

  if (search.query.isEmpty && !search.hasActiveFilters) {
    return repository.getProperties();
  }

  return repository.searchProperties(
    query: search.query.isNotEmpty ? search.query : null,
    propertyType: search.propertyType,
    status: search.status,
    minPrice: search.minPrice,
    maxPrice: search.maxPrice,
    minSurface: search.minSurface,
    maxSurface: search.maxSurface,
    city: search.city,
    isRented: search.isRented,
  );
});

/// Provider du detail d'un bien par son identifiant.
final propertyDetailProvider =
    FutureProvider.autoDispose.family<PropertyEntity, String>((ref, id) async {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.getPropertyById(id);
});
