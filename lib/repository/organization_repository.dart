import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/api_provider.dart';

class OrganizationRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<Organization>> getOrganization(userNummer, isActive, isApproved) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {"yassigto": userNummer, "yactiv": isActive, "yorgapp": isApproved};

    final response = await _provider.post("/getorganization", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Organization> myRoute = list.map((obj) => Organization.fromJson(obj)).toList();
    return myRoute;
  }
  

  
  Future<List<Organization>> getOrganizationByApprover(userNummer, isActive, isApproved, approverName) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {"yassigto": userNummer, "yactiv": isActive, "yorgapp": isApproved, "yorgappu": approverName};

    final response = await _provider.post("/getorgbyapprover", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Organization> myRoute = list.map((obj) => Organization.fromJson(obj)).toList();
    return myRoute;
  }

  Future<List<Organization>> getOrganizationByLocation(minLongitude, maxLongitude, minLatitude, maxLatitude) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {"ygpslat": minLatitude + "!" + maxLatitude, "ygpslon": minLongitude + "!" + maxLongitude};

    final response = await _provider.post("/getorgbyloc", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Organization> myRoute = list.map((obj) => Organization.fromJson(obj)).toList();
    return myRoute;
  }

  Future<List<Organization>> getOrganizationByType(organizationType) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {
      "ycustyp": organizationType,
      "yactiv": "true"
      };

    final response = await _provider.post("/getcustypeorganization", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Organization> myRoute = list.map((obj) => Organization.fromJson(obj)).toList();
    return myRoute;
  }
}
