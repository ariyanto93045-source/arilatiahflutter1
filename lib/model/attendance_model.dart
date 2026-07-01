import 'package:json_annotation/json_annotation.dart';

part 'attendance_model.g.dart';

int? _intFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

@JsonSerializable()
class AttendanceModel {
  @JsonKey(fromJson: _intFromJson)
  final int? id;
  
  @JsonKey(name: 'attendance_date')
  final String? attendanceDate;
  
  @JsonKey(name: 'check_in_time')
  final String? checkInTime;
  
  @JsonKey(name: 'check_out_time')
  final String? checkOutTime;
  
  @JsonKey(name: 'check_in_location')
  final String? checkInLocation;
  
  @JsonKey(name: 'check_out_location')
  final String? checkOutLocation;
  
  @JsonKey(name: 'check_in_address')
  final String? checkInAddress;
  
  @JsonKey(name: 'check_out_address')
  final String? checkOutAddress;
  
  final String? status;
  
  @JsonKey(name: 'alasan_izin')
  final String? alasanIzin;
  
  @JsonKey(name: 'check_in_lat', fromJson: _doubleFromJson)
  final double? checkInLat;
  
  @JsonKey(name: 'check_in_lng', fromJson: _doubleFromJson)
  final double? checkInLng;
  
  @JsonKey(name: 'check_out_lat', fromJson: _doubleFromJson)
  final double? checkOutLat;
  
  @JsonKey(name: 'check_out_lng', fromJson: _doubleFromJson)
  final double? checkOutLng;

  AttendanceModel({
    this.id,
    this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLocation,
    this.checkOutLocation,
    this.checkInAddress,
    this.checkOutAddress,
    this.status,
    this.alasanIzin,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceModelToJson(this);
}
