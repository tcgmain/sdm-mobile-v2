import 'dart:convert';
import 'package:sdm/models/mark_visit.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class MarkVisitRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<MarkVisit> markVisit(String username, String organiz, String route, String date, String time) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};
    inputBody = <String, String>{
      "nummer": "",
      "such": "",
      "ysdmempv": username, //SDM Employee
      "yorg": organiz, //SDM Organization
      "yvrout": route, //Route
      "yvdat": date, //Visit Date
      "yvtim": time //Visit Time
    };
    //print(inputBody);
    final response = await _provider.post("/updatevisit", jsonEncode(inputBody), requestHeaders);
    //print(response);

    return MarkVisit.fromJson(response);
  }
}
