import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/customer_type.dart';
import 'package:sdm/networking/api_provider.dart';

class CustomerTypeRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic requestHeaders;

  Future<List<CustomerType>> getCustomerType() async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await _provider.get("/getcustomertype", requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<CustomerType> cusType = list.map((obj) => CustomerType.fromJson(obj)).toList();
    return cusType;
  }
}
