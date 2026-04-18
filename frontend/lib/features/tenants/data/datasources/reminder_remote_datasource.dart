import 'package:dio/dio.dart';

import '../../domain/entities/reminder_entity.dart';
import '../models/reminder_model.dart';

/// Source distante pour les rappels.
class ReminderRemoteDatasource {
  ReminderRemoteDatasource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<ReminderEntity>> getByTenant(String tenantId) async {
    final response = await _dio.get(
      '/reminders',
      queryParameters: {'tenantId': tenantId},
    );
    final list = response.data as List<dynamic>;
    return list
        .map((json) =>
            ReminderModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }

  Future<ReminderEntity> create(ReminderModel model) async {
    final response = await _dio.post(
      '/reminders',
      data: model.toCreateJson(),
    );
    return ReminderModel.fromJson(response.data as Map<String, dynamic>)
        .toEntity();
  }

  Future<ReminderEntity> update(ReminderModel model) async {
    final response = await _dio.put(
      '/reminders/${model.id}',
      data: model.toUpdateJson(),
    );
    return ReminderModel.fromJson(response.data as Map<String, dynamic>)
        .toEntity();
  }

  Future<void> delete(String id) async {
    await _dio.delete('/reminders/$id');
  }
}
