import 'package:json_annotation/json_annotation.dart';

part 'attendance_stats_model.g.dart';

int? _intFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

@JsonSerializable()
class AttendanceStatsModel {
  @JsonKey(name: 'total_absen', fromJson: _intFromJson)
  final int? totalAbsen;

  @JsonKey(name: 'total_masuk', fromJson: _intFromJson)
  final int? totalMasuk;

  @JsonKey(name: 'total_izin', fromJson: _intFromJson)
  final int? totalIzin;

  @JsonKey(name: 'sudah_absen_hari_ini')
  final bool? sudahAbsenHariIni;

  AttendanceStatsModel({
    this.totalAbsen,
    this.totalMasuk,
    this.totalIzin,
    this.sudahAbsenHariIni,
  });

  factory AttendanceStatsModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceStatsModelToJson(this);
}
