import 'dart:convert';
import 'package:sdm/models/user_details.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class UserDetailsRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;
 
  Future<List<UserDetails>> getUserDetails(String username) async {

    requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    inputBody = {
      "ypasdef^bezeich": username,
    };


    final response = await _provider.post("/getuserdetails", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<UserDetails> userDetails = list.map((obj) => UserDetails.fromJson(obj)).toList();
    return userDetails;
  }



  
}
