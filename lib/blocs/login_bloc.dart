import 'dart:async';
import 'package:sdm/models/login.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  late LoginRepository _loginRepository;
  StreamController? _loginController;

  StreamSink<Response<Login>> get loginSink => _loginController!.sink as StreamSink<Response<Login>>;
  Stream<Response<Login>> get loginStream => _loginController!.stream as Stream<Response<Login>>;

  LoginBloc() {
    _loginController = StreamController<Response<Login>>.broadcast();
    _loginRepository = LoginRepository();
  }

  //Getting login response
  login(String username, String password, String deviceId) async {
    if (_loginController?.isClosed ?? true) return;
    loginSink.add(Response.loading(''));
    try {
      Login res = await _loginRepository.getLoginData(username, password, deviceId);
      if (_loginController?.isClosed ?? true) return;
      loginSink.add(Response.completed(res));

      //Saving username in local storage
      SharedPreferences prefsUserName = await SharedPreferences.getInstance();
      await prefsUserName.setString('username', res.ylogopr.toString());
      SharedPreferences prefsUserId = await SharedPreferences.getInstance();
      await prefsUserId.setString('userId', res.ypwdid.toString());
     
      print("LOGIN SUCCESS");
    }
    
    catch (e) {
      if (_loginController?.isClosed ?? true) return;
      loginSink.add(Response.error(e.toString()));
      print("LOGIN ERROR");
      print(e);
    }
  }

  dispose() {
    _loginController?.close();
  }
}
