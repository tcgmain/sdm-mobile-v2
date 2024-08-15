import 'dart:convert';
import 'dart:async';
import 'package:sdm/models/add_goods_management.dart';
import 'package:sdm/networking/api_provider.dart';

class AddGoodsManagementRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<AddGoodsManagement> addGoodsManagement(
    String goodsManagementSearchWord,
    String organizationNummer,
  ) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    inputBody = <String, String>{"such": goodsManagementSearchWord, "yorg": organizationNummer};

    final response = await _provider.post("/addgoodsmanagement", jsonEncode(inputBody), requestHeaders);
    return AddGoodsManagement.fromJson(response);
  }
}
