import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/Bdnotification.dart';
import 'package:sdm/networking/api_provider.dart';

class BdnotificationRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<Bdnotification>> getBdnotification(yterritory_nummer) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print('yyyy');
    inputBody = <String, String>{"yterritory^nummer": yterritory_nummer};

    final response = await _provider.post("/getorgbyterritory", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Bdnotification> route = list.map((obj) => Bdnotification.fromJson(obj)).toList();
    return route;
  }
}
