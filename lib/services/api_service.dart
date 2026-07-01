import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/user_model.dart';
import '../model/training_model.dart';
import '../model/batch_model.dart';
import '../model/auth_response.dart';
import '../model/api_response.dart';
import '../model/attendance_model.dart';
import '../model/attendance_stats_model.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST('/api/register')
  Future<ApiResponse<AuthResponse>> register(@Body() Map<String, dynamic> body);

  @POST('/api/login')
  Future<ApiResponse<AuthResponse>> login(@Body() Map<String, dynamic> body);

  @GET('/api/profile')
  Future<ApiResponse<UserModel>> getProfile();

  @PUT('/api/profile')
  Future<ApiResponse<UserModel>> updateProfile(@Body() Map<String, dynamic> body);

  @PUT('/api/profile/photo')
  Future<ApiResponse<UserModel>> updateProfilePhoto(@Body() Map<String, dynamic> body);

  @GET('/api/users')
  Future<ApiResponse<List<UserModel>>> getUsers();

  @GET('/api/trainings')
  Future<ApiResponse<List<TrainingModel>>> getTrainings();

  @GET('/api/trainings/{id}')
  Future<ApiResponse<TrainingModel>> getTrainingDetail(@Path("id") int id);

  @GET('/api/batches')
  Future<ApiResponse<List<BatchModel>>> getBatches();

  @POST('/api/absen/check-in')
  Future<ApiResponse<AttendanceModel>> checkIn(@Body() Map<String, dynamic> body);

  @POST('/api/absen/check-out')
  Future<ApiResponse<AttendanceModel>> checkOut(@Body() Map<String, dynamic> body);

  @GET('/api/absen/today')
  Future<ApiResponse<AttendanceModel>> getTodayAttendance(@Query("attendance_date") String date);

  @GET('/api/absen/stats')
  Future<ApiResponse<AttendanceStatsModel>> getAttendanceStats();

  @GET('/api/absen/history')
  Future<ApiResponse<List<AttendanceModel>>> getAttendanceHistory();

  @DELETE('/api/absen/{id}')
  Future<ApiResponse<dynamic>> deleteAttendance(@Path("id") int id);
}
