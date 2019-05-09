import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io';
import '../config/HttpConfig.dart';

class Server{

  //日志log
  static httpPrint(String httpLog){
    print("HTTPLOG: $httpLog");
  }

   Future doPost({String url,Map<String,Object> map,httpError (),error (e)}) async {
    httpPrint("Request Start: $url");
    httpPrint("Request Params: ${map.toString()}");
    try{
      Response response;
      response = await Dio().post(url,queryParameters: map);

      if(response.statusCode == HTTP_SUCCESS_CODE){
        httpPrint("Request Data: ${response.data}");
        httpPrint("Request Done!");

        return response.data;
      }else{
        httpPrint("Request httpError: ${response.statusCode}");
        httpError();
      }
    }catch(e){
      httpPrint("Request error! ${e.toString()}");
      error(e);
    }
  }

  Future doGet({String url,Map<String,Object> map,httpError (),error (e)}) async {
    httpPrint("Request Start: $url");
    httpPrint("Request Params: ${map.toString()}");
    try{
      Response response;
      response = await Dio().get(url,queryParameters: map);

      if(response.statusCode == HTTP_SUCCESS_CODE){
        httpPrint("Request Data: ${response.data}");
        httpPrint("Request Done!");

        return response.data;
      }else{
        httpPrint("Request httpError: ${response.statusCode}");
        httpError();
      }
    }catch(e){
      httpPrint("Request error! ${e.toString()}");
      error(e);
    }
  }
}
