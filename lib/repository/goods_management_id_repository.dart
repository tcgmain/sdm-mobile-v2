import 'dart:convert';
import 'package:sdm/models/goods_management_id.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class GoodManagementIdRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

Future<List<GoodManagementID>> getGoodManagementID(organizationNummer) async {
  // Define request headers
  requestHeaders = <String, String> {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Define input body
  inputBody = {
    // Include any necessary parameters
    "yorg^nummer": organizationNummer,
  };

  final response = await _provider.post("/getgmid",jsonEncode(inputBody),requestHeaders);
  var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<GoodManagementID> getGoodMgt = list.map((obj) => GoodManagementID.fromJson(obj)).toList();
    return getGoodMgt;
  }
}