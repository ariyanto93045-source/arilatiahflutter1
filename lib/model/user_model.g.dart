// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: _intFromJson(json['id']),
  name: json['name'] as String?,
  email: json['email'] as String?,
  jenisKelamin: json['jenis_kelamin'] as String?,
  batchId: _intFromJson(json['batch_id']),
  trainingId: _intFromJson(json['training_id']),
  profilePhoto: json['profile_photo'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'jenis_kelamin': instance.jenisKelamin,
  'batch_id': instance.batchId,
  'training_id': instance.trainingId,
  'profile_photo': instance.profilePhoto,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
