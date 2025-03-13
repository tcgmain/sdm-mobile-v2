import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/organization_category.dart';
import 'package:sdm/networking/api_provider.dart';

class OrganizationCategoryRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic requestHeaders;

  Future<List<OrganizationCategory>> getOrganizationCategory() async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await _provider.get("/getorgcat", requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<OrganizationCategory> orgCat = list.map((obj) => OrganizationCategory.fromJson(obj)).toList();
    return orgCat;
  }
}
