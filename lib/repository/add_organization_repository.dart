import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/add_organization.dart';
import 'package:sdm/networking/api_provider.dart';

class AddOrganizationRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<AddOrganization> addOrganization(
      String searchWord,
      String name,
      String email,
      String phone1,
      String phone2,
      String whatsapp,
      String address1,
      String address2,
      String address3,
      String town,
      String latitude,
      String longitude,
      String customerTypeId,
      String assignToNummer,
      String userOrganizationNummer,
      String ownerName,
      String ownerBirthday,
      String isMasonry,
      String isWaterproofing,
      String isFlooring,
      String organizationColor,
      String superiorOrganization) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    inputBody = <String, String>{
      "nummer": "",
      "such": searchWord,
      "namebspr": name,
      "yemail": email,
      "yphone1": phone1,
      "yphone2": phone2,
      "ywhtapp": whatsapp,
      "yaddressl1": address1,
      "yaddressl2": address2,
      "yaddressl3": address3,
      "yaddressl4": town,
      "ygpslat": latitude,
      "ygpslon": longitude,
      "ycustyp": customerTypeId,
      "yassigto": assignToNummer,
      "yvisdis": "300",
      "ysuporg": superiorOrganization,
      "yowname": ownerName,
      "yorgowndob": ownerBirthday,
      "ymasonry": isMasonry,
      "ywaterpr": isWaterproofing,
      "yflooring": isFlooring,
      "yselcolour": organizationColor
    };

    final response = await _provider.post("/addorganization", jsonEncode(inputBody), requestHeaders);
    return AddOrganization.fromJson(response);
  }
}
