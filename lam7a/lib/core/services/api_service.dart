import 'package:dio/dio.dart';
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

@Riverpod(keepAlive: true)
Openapi apiClient(Ref ref){
  final dio = Dio(BaseOptions(
    baseUrl: ServerConstant.serverURL, // your API base URL
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  final apiClient = Openapi(dio: dio);

  return apiClient;
}