import 'package:SomanyHIL/model/common_response.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/model/login_data.dart';
import 'package:SomanyHIL/model/product_catalog.dart';
import 'package:SomanyHIL/model/user_device.dart';
import 'package:SomanyHIL/model/refresh_token.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'eightfolds_retrofit.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: EightFoldsRetrofit.BASE_URL)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('api/user/login')
  Future<LoginData> login(
      {@Query('userName') String userName, @Query('password') String password});

  @GET('api/secure/user/login')
  Future<LoginData> secureLogin();

  @GET('api/secure/refreshtoken')
  Future<RefreshToken> getRefreshToken();

  @GET('api/get/products')
  Future<List<ProductCatalog>> getAllProducts(
      {@Query('page') int page, @Query('pageSize') int pageSize});

  @GET('api/secure/inspections/between')
  Future<List<Inspection>> getInspectionHistory(
      {@Query('startDate') String startDate,
      @Query('endDate') String endDate,
      @Query('page') int page,
      @Query('pageSize') int pageSize});

  @POST('api/secure/user/submit/instructions')
  Future<CommonResponse> submitInspections({@Body() String list});

  @POST('api/secure/user/push/device')
  Future<CommonResponse> updateDeviceInfo(@Body() UserDevice userDevice);
}
