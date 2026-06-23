import 'package:arilatiahflutter1/model/product_models.dart';
import 'package:dio/dio.dart';
// import 'package:ppkd_b6/day_33/models/post_models.dart';
import 'package:retrofit/retrofit.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: 'https://fakestoreapi.com/')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/products')
  Future<List<PosModel>> getAllProduct();
}
