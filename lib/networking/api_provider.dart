// ignore_for_file: prefer_typing_uninitialized_variables

import 'custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

bool flag1 = false;

class ApiProvider {
  //Common URL of API calls
  var baseUrl = "http://192.168.100.33:1246";
  Future<dynamic> post(String url, inputBody, requestHeaders) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(baseUrl + url), headers: requestHeaders, body: inputBody);
      String responseString = response.body.toString();
      //print(responseString);
      //print(inputBody);
      //print(baseUrl + url);
      responseJson = _response(jsonDecode(responseString), response.statusCode);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

    Future<dynamic> get(String url, requestHeaders) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(baseUrl + url), headers: requestHeaders);
      String responseString = response.body.toString();
      //print(responseString);
      //print(inputBody);
      //print(baseUrl + url);
      responseJson = _response(jsonDecode(responseString), response.statusCode);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  dynamic _response(response, statusCode) {
    switch (statusCode) {
      case 200:
        if (response["success"] == true) {
          flag1 = true;
          return response["result_data"];
        } else {
          throw AbasException(response["message"]);
        }
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error with StatusCode : ${response.statusCode}');
    }
  }
}
