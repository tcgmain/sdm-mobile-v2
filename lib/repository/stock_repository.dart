import 'dart:convert';
import 'package:sdm/models/stock.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class StockRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<Stock> getProductStock(String userNummer, String organizationNummer) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    Map<String, dynamic> inputBody = {
      "id": "(310,77,0)",
      "ysdmemp": userNummer,
      "ysdmorg": organizationNummer,
      "table": [
        {"yprodnummer": "", 
        "yprodsuch": "", 
        "yproddesc": "", 
        "ycurstoc": "", 
        "ylastud": "", 
        "ylastub": ""}
      ]
    };

    final response = await _provider.post("/getproduct", jsonEncode(inputBody), requestHeaders);
    return Stock.fromJson(response);
  }
}
