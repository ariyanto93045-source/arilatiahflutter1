// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchModel _$BatchModelFromJson(Map<String, dynamic> json) => BatchModel(
  id: _intFromJson(json['id']),
  title: json['title'] as String?,
  name: json['name'] as String?,
  batchKe: json['batch_ke'] as String?,
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
);

Map<String, dynamic> _$BatchModelToJson(BatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'name': instance.name,
      'batch_ke': instance.batchKe,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
    };
