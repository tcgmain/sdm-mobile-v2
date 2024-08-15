import 'dart:async';
import 'package:sdm/models/permission.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/permission_repository.dart';

class PermissionBloc {
  late PermissionRepository _permissionRepository;
  StreamController? _permissionController;

  StreamSink<ResponseList<Permission>> get permissionSink =>
      _permissionController!.sink as StreamSink<ResponseList<Permission>>;
  Stream<ResponseList<Permission>> get permissionStream =>
      _permissionController!.stream as Stream<ResponseList<Permission>>;

  PermissionBloc() {
    _permissionController = StreamController<ResponseList<Permission>>.broadcast();
    _permissionRepository = PermissionRepository();
  }

  getPermission(String such, String userId) async {
   
    permissionSink.add(ResponseList.loading(''));
    try {
      List<Permission> res = await _permissionRepository.getPermission(such, userId);
      permissionSink.add(ResponseList.completed(res));

      print("PERMISSION SUCCESS");
    } catch (e) {
      permissionSink.add(ResponseList.error(e.toString()));
      print("PERMISSION ERROR $e");
    }
  }

  dispose() {
    _permissionController?.close();
  }
}
