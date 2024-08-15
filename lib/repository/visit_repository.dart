import 'dart:convert';
import 'dart:async';
import 'package:sdm/models/visit.dart';
import 'package:sdm/networking/api_provider.dart';

class VisitRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<Visit>> getVisit(userNummer, organizationNummer) async {

    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {
      "ysdmempv^nummer": userNummer,
      "yorg^nummer": organizationNummer
    };

    final response = await _provider.post("/getvisit", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Visit> visitList = list.map((obj) => Visit.fromJson(obj)).toList();
    return visitList;
  }
}
