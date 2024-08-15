import 'dart:convert';

import 'package:sdm/models/create_so.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class CreateSoRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<CreateSO> createSO(
      String userNummer, String date, String organizationFromNummer, String organizationToNummer, orderedList) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    inputBody = {
      "nummer": "",
      "such": "",
      "ysdemp": userNummer, //Employee Code
      "ydat": date, //SO Date
      "ysdorgorfr": organizationFromNummer, //Order From - Organization Code
      "ysdorg": organizationToNummer, //Order To - Organization Code
      "table": orderedList
    };

    final response = await _provider.post("/createso", jsonEncode(inputBody), requestHeaders);
    return CreateSO.fromJson(response);
    
  }
}
