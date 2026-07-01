// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceStatsModel _$AttendanceStatsModelFromJson(
  Map<String, dynamic> json,
) => AttendanceStatsModel(
  totalAbsen: _intFromJson(json['total_absen']),
  totalMasuk: _intFromJson(json['total_masuk']),
  totalIzin: _intFromJson(json['total_izin']),
  sudahAbsenHariIni: json['sudah_absen_hari_ini'] as bool?,
);

Map<String, dynamic> _$AttendanceStatsModelToJson(
  AttendanceStatsModel instance,
) => <String, dynamic>{
  'total_absen': instance.totalAbsen,
  'total_masuk': instance.totalMasuk,
  'total_izin': instance.totalIzin,
  'sudah_absen_hari_ini': instance.sudahAbsenHariIni,
};
