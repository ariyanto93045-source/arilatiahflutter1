// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    AttendanceModel(
      id: _intFromJson(json['id']),
      attendanceDate: json['attendance_date'] as String?,
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      checkInLocation: json['check_in_location'] as String?,
      checkOutLocation: json['check_out_location'] as String?,
      checkInAddress: json['check_in_address'] as String?,
      checkOutAddress: json['check_out_address'] as String?,
      status: json['status'] as String?,
      alasanIzin: json['alasan_izin'] as String?,
      checkInLat: _doubleFromJson(json['check_in_lat']),
      checkInLng: _doubleFromJson(json['check_in_lng']),
      checkOutLat: _doubleFromJson(json['check_out_lat']),
      checkOutLng: _doubleFromJson(json['check_out_lng']),
    );

Map<String, dynamic> _$AttendanceModelToJson(AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attendance_date': instance.attendanceDate,
      'check_in_time': instance.checkInTime,
      'check_out_time': instance.checkOutTime,
      'check_in_location': instance.checkInLocation,
      'check_out_location': instance.checkOutLocation,
      'check_in_address': instance.checkInAddress,
      'check_out_address': instance.checkOutAddress,
      'status': instance.status,
      'alasan_izin': instance.alasanIzin,
      'check_in_lat': instance.checkInLat,
      'check_in_lng': instance.checkInLng,
      'check_out_lat': instance.checkOutLat,
      'check_out_lng': instance.checkOutLng,
    };
