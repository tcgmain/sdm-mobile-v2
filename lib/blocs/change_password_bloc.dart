import 'dart:async';
import 'package:sdm/models/change_password.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/change_password_repository.dart';

class ChangePasswordBloc {
  late ChangePasswordRepository _changePasswordRepository;
  StreamController? _changePasswordController;

  StreamSink<Response<ChangePassword>> get changePasswordSink =>
      _changePasswordController!.sink as StreamSink<Response<ChangePassword>>;
  Stream<Response<ChangePassword>> get changePasswordStream =>
      _changePasswordController!.stream as Stream<Response<ChangePassword>>;

  ChangePasswordBloc() {
    _changePasswordController = StreamController<Response<ChangePassword>>.broadcast();
    _changePasswordRepository = ChangePasswordRepository();
  }

  changePassword(String newpassword, userId) async {
    changePasswordSink.add(Response.loading(''));
    try {
      ChangePassword res = await _changePasswordRepository.changeNewPassword(newpassword, userId);
      changePasswordSink.add(Response.completed(res));
      print("CHANGE PASSWORD SUCCESSFULLY");
    } catch (e) {
      changePasswordSink.add(Response.error(e.toString()));
      print("CHANGE PASSWORD FAIL $e");
    }
  }

  dispose() {
    _changePasswordController?.close();
  }
}
