import 'dart:convert';
import 'dart:async';
import 'package:sdm/models/update_organization.dart';
import 'package:sdm/networking/api_provider.dart';

class UpdateOrganizationRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<UpdateOrganization> updateOrganization(
      String id,
      String email,
      String ownerName,
      String phone1,
      String phone2,
      String whatsapp,
      String address1,
      String address2,
      String address3,
      String town,
      String customerTypeId,
      String isMasonry,
      String isWaterproofing,
      String isFlooring,
      String organizationColor,
      String superiorOrganization
      ) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    inputBody = <String, String>{
      "id": id,
      "yemail": email,
      "yowname": ownerName,
      "yphone1": phone1,
      "yphone2": phone2,
      "ywhtapp": whatsapp,
      "yaddressl1": address1,
      "yaddressl2": address2,
      "yaddressl3": address3,
      "yaddressl4": town,
      "ycustyp": customerTypeId,
      "ymasonry": isMasonry,
      "ywaterpr": isWaterproofing,
      "yflooring": isFlooring,
      "yselcolour": organizationColor,
      "ysuporg": superiorOrganization
    };

    final response = await _provider.post("/updateorganization", jsonEncode(inputBody), requestHeaders);
    return UpdateOrganization.fromJson(response);
  }

  Future<UpdateOrganization> updateSuperiorOrganization(
      String organizationId, String superiorOrganizationNummer) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    inputBody = <String, String>{
      "id": organizationId,
      "ysuporg": superiorOrganizationNummer,
    };

    final response = await _provider.post("/updateorganization", jsonEncode(inputBody), requestHeaders);
    return UpdateOrganization.fromJson(response);
  }
}
