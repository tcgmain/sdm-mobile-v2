import 'dart:convert';
import 'package:sdm/models/update_route.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class UpdateRouteRepository {
  final ApiProvider _provider = ApiProvider();

  Future<UpdateRoute> updateRoute(String routeId, String organizationNummer) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> inputBody = {
      "id": routeId,
      "table": [
        {
            "ysdmorg": organizationNummer
        }
      ]
    };

    try {
      final response = await _provider.post("/updateroute", jsonEncode(inputBody), requestHeaders);
      return UpdateRoute.fromJson(response);
    } catch (e) {
      throw Exception('Stock Update FAIL: $e');
    }
  }
}
