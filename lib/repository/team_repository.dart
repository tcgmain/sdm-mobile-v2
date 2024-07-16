import 'dart:convert';
import 'package:sdm/models/team.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class TeamRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;
 
  Future<List<Team>> getTeamDetails(String username) async {

    requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    inputBody = {
      "ysupv^nummer": username,
    };


    final response = await _provider.post("/getteam", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Team> team = list.map((obj) => Team.fromJson(obj)).toList();
    return team;
  }



  
}
