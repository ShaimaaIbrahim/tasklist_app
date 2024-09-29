
import 'dart:convert';

import 'package:dio/dio.dart';

enum Method {
  POST, GET, PATCH, DELETE
}

class HttpService {
  Dio? _dio;
  
  Future<HttpService> init(BaseOptions options) async{
    _dio = Dio(options);
    return this;
  }

   request({
    required String endPoint, 
    required Method method, 
    Map<String, dynamic>? params,
    Map<String, dynamic>? queryParams
  }) async{
    Response response;
    try{
      switch(method){
        
        case Method.POST:
          response = await _dio!.post(endPoint, data: json.encode(params));
          break;
          
        case Method.GET:
        response = await _dio!.get(endPoint, queryParameters: queryParams, data: json.encode(params));
        break;
        
        case Method.PATCH:
          response = await _dio!.patch(endPoint, data: json.encode(params));
          break;
          
        case Method.DELETE:
        response = await _dio!.delete(endPoint);
        break;
      }
      return response;
    }on DioException catch(e){
      return e;
    }
  }
}