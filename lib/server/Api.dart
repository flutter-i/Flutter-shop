import 'Server.dart';
import 'dart:async';
import '../config/HttpConfig.dart';
import 'package:dio/dio.dart';

Future getHomeData(map,{httpError (),error (e)}) {
  return Server().doPost(url: URL['homePageContent'],map: map,httpError: httpError,error: error);
}

Future getHot(map,{httpError (),error (e)}) {
  return Server().doPost(url: URL['homePageBelowConten'],map: map,httpError: httpError,error: error);
}
