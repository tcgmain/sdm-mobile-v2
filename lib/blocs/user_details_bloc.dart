import 'dart:async';
import 'package:sdm/models/user_details.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/user_details_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsBloc {
  late UserDetailsRepository _userDetailsRepository;
  StreamController? _userDetailsController;

  StreamSink<ResponseList<UserDetails>> get userDetailsSink =>
      _userDetailsController!.sink as StreamSink<ResponseList<UserDetails>>;
  Stream<ResponseList<UserDetails>> get userDetailsStream =>
      _userDetailsController!.stream as Stream<ResponseList<UserDetails>>;

  UserDetailsBloc() {
    _userDetailsController = StreamController<ResponseList<UserDetails>>.broadcast();
    _userDetailsRepository = UserDetailsRepository();
  }

  getUserDetails(String username) async {
    userDetailsSink.add(ResponseList.loading(''));
    try {
      List<UserDetails> res = await _userDetailsRepository.getUserDetails(username);
      userDetailsSink.add(ResponseList.completed(res));
      //Saving userDetails in local storage
      SharedPreferences prefsUserID = await SharedPreferences.getInstance();
      await prefsUserID.setString('userNummer', res[0].nummer.toString());

      SharedPreferences prefsUserOrganizationNummer = await SharedPreferences.getInstance();
      await prefsUserOrganizationNummer.setString('userOrganizationNummer', res[0].yorgNummer.toString());

      SharedPreferences prefsUserDesignationNummer = await SharedPreferences.getInstance();
      await prefsUserDesignationNummer.setString('userDesignationNummer', res[0].yorgNummer.toString());

      print("USER DETAILS SUCCESS");
    } catch (e) {
      userDetailsSink.add(ResponseList.error(e.toString()));
      print("USER DETAILS ERROR");
      print(e);
    }
  }

  dispose() {
    _userDetailsController?.close();
  }
}
