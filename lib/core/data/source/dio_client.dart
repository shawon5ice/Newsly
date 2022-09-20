import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../di/app_component.dart';
import '../../logger/logger.dart';
import '../../session/session_manager.dart';
import '../../utils/messages.dart';
import 'package:http/http.dart' as http;

class DioClient {
  final Dio dio;

  DioClient(this.dio);


  Future<Response?> post({
    required String path,
    dynamic request,
    required Function(dynamic, String?) responseCallback,
    required Function(String?, int?) failureCallback,
    dynamic header,
  }) async {
    Response? response;
    print(request);
    var connectivityResult = await (Connectivity().checkConnectivity());
    try {
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        response = await dio.post(path,
          data: request,
          options: Options(
            headers: header,
            contentType: Headers.formUrlEncodedContentType,
            receiveTimeout: 5000,
          ),
        );
        if (response.data != null && response.statusCode == HttpStatus.ok) {
          responseCallback(response.data, response.statusMessage);
        } else {
          failureCallback(response.statusMessage, response.statusCode);
        }
      } else if (connectivityResult == ConnectivityResult.none) {
        failureCallback(noInternetConnectionMessage, 12029);
      }
    } on Exception catch (e, _){
      logger.printErrorLog("Response code: ${response?.statusCode}");
      logger.printErrorLog(e);
      failureCallback(tryAgainErrorMessage, 400);
    }
    return response;
  }

  // Future<UploadResponse?> postUpload({
  //   required String path,
  //   dynamic request,
  //   required Function(dynamic) responseCallback,
  //   required Function(String?, int?) failureCallback,
  //   dynamic header,
  // }) async {
  //
  //   Response? response;
  //
  //       print("$request");
  //      // //print(request["Image"]);
  //      // print('status: '+request["status"]);
  //      // print('Company: '+request["Company"]);
  //      // print('Company: '+request["DocumentType"]);
  //   var headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded'
  //   };
  //   var formData = FormData.fromMap({
  //     'Image': '${request["Image"]}',
  //     'status': '${request["status"]}',//'101075',
  //     'Company': '${request["Company"]}',
  //     'DocumentType': '${request["DocumentType"]}'
  //   });
  //   try{
  //     response = await dio.post('https://corporate3.bdjobs.com/api/v1/Uddokta/DocumentUpload.aspx', data: formData, options: Options(headers: headers));
  //     print("Rsponse : "+response.toString());
  //
  //     if (response.statusCode == 200) {
  //       responseCallback(response.data);
  //     }else {
  //       failureCallback("অনুগ্রহ করে চেষ্টা করুন!", response.statusCode);
  //     }
  //   }on Exception catch (e, _){
  //     failureCallback("অনুগ্রহ করে চেষ্টা করুন!", 500);
  //   }
  //
  //  // return response;
  // }



  // Future<LoginWithIdPassResponse?> loginUserNamePass({
  //   required String userNmae,
  //   required String pass,
  //   required Function(dynamic) responseCallback,
  //   required Function(String?, int?) failureCallback,
  // }) async {
  //
  //
  //   var headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded'
  //   };
  //   var request = https.Request('POST', Uri.parse('https://corporate3.bdjobs.com//api/v1/CorporateAuthentication_uddokta.asp'));
  //   request.bodyFields = {
  //     'NAME': userNmae,
  //     'PASS': pass,
  //     'IsUddokta': '1'
  //   };
  //   request.headers.addAll(headers);
  //
  //   https.StreamedResponse response = await request.send();
  //
  //
  //   if (response.statusCode == 200) {
  //     var stringObject = await response.stream.bytesToString();
  //
  //     print(stringObject);
  //     //LoginWithIdPassResponse loginresponse = LoginWithIdPassResponse.fromJson(jsonDecode(stringObject));
  //     var jsonDecodeString = jsonDecode(stringObject);
  //     // print("response msg: ${loginresponse.message}");
  //     // print("Auth: ${loginresponse.data![0].userauth}");
  //   //  return loginresponse;
  //
  //     responseCallback(jsonDecodeString);
  //   }else{
  //     failureCallback("অনুগ্রহ করে চেষ্টা করুন!", response.statusCode);
  //   }
  //
  //
  //
  //
  // //  return response;
  // }

  Future<Response?> get({
    required String path,
    dynamic request,
    required Function(dynamic, String?) responseCallback,
    required Function(String?, int?) failureCallback,
    Map<String, String>? queryParameters,
    bool includeHeader = false,
  }) async {
    Response? response;
    var connectivityResult = await (Connectivity().checkConnectivity());

    try {
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        response = await dio.get(path,
          queryParameters: queryParameters,
          options: Options(
            headers: includeHeader ? getHeader(locator<SessionManager>()) : {},
            contentType: Headers.formUrlEncodedContentType,
            receiveTimeout: 3000,
          ),
        );
        if (response.data != null && response.statusCode == HttpStatus.ok) {
          responseCallback(response.data, response.statusMessage);
        } else {
          failureCallback(response.statusMessage, response.statusCode);
        }
      } else if (connectivityResult == ConnectivityResult.none) {
        failureCallback(noInternetConnectionMessage, 12029);
      }
    } on Exception catch (e, _){
      failureCallback(tryAgainErrorMessage, 400);
    }
    return response;
  }

  Map<String, dynamic> getHeader(SessionManager session) {
    return kDebugMode ? {
      // "X_API_COMPANY_CODE" : 'E3298E3B',
      // "X_API_COMPANY_ID" : '35450',
      // "X_API_COMPANY_CREATION" : '9/12/2012 12:38:00 PM',
      // "X_API_AUTH" : "0",
      // "X_API_Login_ID": "138253"
      // "X_API_COMPANY_CODE" : session.companyCode,//'YUQXHDBX',
      // "X_API_COMPANY_ID" : session.companyId,//'101075',
      // "X_API_COMPANY_CREATION" : session.companyCreation,
      // "X_API_AUTH" : session.comCODE,
      // "X_API_Login_ID": session.loginId,
    } : {
      // "X_API_COMPANY_CODE" : session.companyCode,
      // "X_API_COMPANY_ID" : session.companyId,
      // "X_API_COMPANY_CREATION" : session.companyCreation,
      // "X_API_AUTH" : session.comCODE,
      // "X_API_Login_ID": session.loginId,
    };
  }
}
