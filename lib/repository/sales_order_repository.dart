import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/sales_order.dart';
import 'package:sdm/networking/api_provider.dart';

class SalesOrderRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<SalesOrder>> getSalesOrder(salesOrderNummer) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    inputBody = {"nummer": salesOrderNummer};
    final response = await _provider.post("/getsalesorder", jsonEncode(inputBody), requestHeaders);
    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }
    var list = itemArray;
    List<SalesOrder> soIn = list.map((obj) => SalesOrder.fromJson(obj)).toList();
    return soIn;
  }
}
