import 'dart:convert';
import 'dart:async';
import 'package:sdm/models/update_organization.dart';
import 'package:sdm/networking/api_provider.dart';

class UpdateOrganizationLocationRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<UpdateOrganization> updateOrganizationLocation(
    String id,
    String longitude,
    String latitude,
    String currentTownNummer,
    String updatedBy,
    String updatedOn,
  ) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    inputBody = <String, String>{
      "id": id,
      "ygpslat": latitude,
      "ygpslon": longitude,
      "ytown": currentTownNummer,
      "locationupdatedby": updatedBy,
      "locationupdatedon": updatedOn
    };

    final response = await _provider.post("/updateorganization", jsonEncode(inputBody), requestHeaders);
    return UpdateOrganization.fromJson(response);
  }
}
