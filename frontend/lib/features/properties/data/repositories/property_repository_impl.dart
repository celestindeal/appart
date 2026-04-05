import '../../domain/entities/profitability_result.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/entities/property_event_entity.dart';
import '../../domain/repositories/property_repository.dart';
import '../../domain/usecases/calculate_profitability_usecase.dart';
import '../datasources/property_remote_datasource.dart';
import '../models/property_event_model.dart';
import '../models/property_model.dart';

/// Implementation concrete du repository des biens immobiliers.
class PropertyRepositoryImpl implements PropertyRepository {
  PropertyRepositoryImpl({
    required PropertyRemoteDatasource remoteDatasource,
    CalculateProfitabilityUsecase? profitabilityUsecase,
  })  : _remoteDatasource = remoteDatasource,
        _profitabilityUsecase =
            profitabilityUsecase ?? CalculateProfitabilityUsecase();

  final PropertyRemoteDatasource _remoteDatasource;
  final CalculateProfitabilityUsecase _profitabilityUsecase;

  @override
  Future<List<PropertyEntity>> getProperties() async {
    final models = await _remoteDatasource.getProperties();
    return models;
  }

  @override
  Future<PropertyEntity> getPropertyById(String id) async {
    return _remoteDatasource.getPropertyById(id);
  }

  @override
  Future<PropertyEntity> createProperty(PropertyEntity property) async {
    final model = PropertyModel.fromEntity(property);
    return _remoteDatasource.createProperty(model);
  }

  @override
  Future<PropertyEntity> updateProperty(PropertyEntity property) async {
    final model = PropertyModel.fromEntity(property);
    return _remoteDatasource.updateProperty(model);
  }

  @override
  Future<void> deleteProperty(String id) async {
    await _remoteDatasource.deleteProperty(id);
  }

  @override
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
  }) async {
    final models = await _remoteDatasource.searchProperties(
      query: query,
      propertyType: propertyType?.name,
      status: status?.name,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minSurface: minSurface,
      maxSurface: maxSurface,
      city: city,
      isRented: isRented,
    );
    return models;
  }

  @override
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
  }) async {
    return _profitabilityUsecase.execute(
      price: price,
      monthlyRent: monthlyRent,
      charges: charges,
      propertyTax: propertyTax,
      insurance: insurance,
      loanRate: loanRate,
      loanDuration: loanDuration,
      downPayment: downPayment,
      renovationCost: renovationCost,
      notaryFeesPercent: notaryFeesPercent,
      surface: surface,
    );
  }

  @override
  Future<PropertyEventEntity> createPropertyEvent(
    PropertyEventEntity event,
  ) async {
    final model = PropertyEventModel.fromEntity(event);
    return _remoteDatasource.createPropertyEvent(model);
  }

  @override
  Future<void> deletePropertyEvent(String eventId) async {
    await _remoteDatasource.deletePropertyEvent(eventId);
  }
}
