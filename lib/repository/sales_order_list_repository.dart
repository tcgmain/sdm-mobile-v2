import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/sales_order.dart';
import 'package:sdm/networking/api_provider.dart';

class SalesOrderListRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<SalesOrder>> getSalesOrderInList(organizationNummer) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {"ysdorg^nummer": organizationNummer};
    final response = await _provider.post("/getsalesorderinlist", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<SalesOrder> soIn = list.map((obj) => SalesOrder.fromJson(obj)).toList();
    return soIn;
  }

  Future<List<SalesOrder>> getSalesOrderOutList(organizationNummer) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {"ysdorgorfr^nummer": organizationNummer};
    final response = await _provider.post("/getsalesorderoutlist", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<SalesOrder> soOut = list.map((obj) => SalesOrder.fromJson(obj)).toList();
    return soOut;
  }
}
