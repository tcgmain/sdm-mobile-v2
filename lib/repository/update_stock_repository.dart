import 'dart:convert';
import 'package:sdm/models/update_stock.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class UpdateStockRepository {
  final ApiProvider _provider = ApiProvider();

  Future<UpdateStock> updateStock(
      String id, String date, String productnummer, String stock, String username, String visitNummer) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> inputBody = {
      "id": id,
      "table": [
        {
          "yentdat": date.toString(), //Entry Date
          "yprod": productnummer.toString(), //Product Code
          "ycurstoc": stock.toString(), //Current Stock
          "yrecqty": "", //Reciept Quantity
          "yissqty": "", //Issue Quantity
          "yvis": visitNummer.toString(), //Visit
          "yuser": username //User
        }
      ]
    };

    try {
      final response = await _provider.post("/updateStock", jsonEncode(inputBody), requestHeaders);
      return UpdateStock.fromJson(response);
    } catch (e) {
      throw Exception('Stock Update FAIL: $e');
    }
  }
}
