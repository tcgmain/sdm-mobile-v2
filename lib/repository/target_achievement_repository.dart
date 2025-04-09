import 'dart:convert';
import 'package:sdm/models/target_achievement.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class TargetAchievementRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<TargetAchievement>> getTargetAchievement(userNummer, year, month) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    inputBody = {"ytargetyr": year, "ytargetmn": month, "ytargetemp": userNummer};

    final response = await _provider.post("/gettargetach", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<TargetAchievement> targetarch = list.map((obj) => TargetAchievement.fromJson(obj)).toList();
    return targetarch;
  }
}
