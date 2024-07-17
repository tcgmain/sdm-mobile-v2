import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/sales_order.dart';
import 'package:sdm/networking/api_provider.dart';

class SalesOrderRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<SalesOrder>> getSalesOrderIn(organizationNummer, salesOrderNummer) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {"ysdorg^nummer": organizationNummer, "nummer": salesOrderNummer};

    final response = await _provider.post("/getsalesorderin", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<SalesOrder> soIn = list.map((obj) => SalesOrder.fromJson(obj)).toList();
    return soIn;
  }

  Future<List<SalesOrder>> getSalesOrderOut(organizationNummer, salesOrderNummer) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {"ysdorgorfr^nummer": organizationNummer, "nummer": salesOrderNummer};

    final response = await _provider.post("/getsalesorderout", jsonEncode(inputBody), requestHeaders);

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
