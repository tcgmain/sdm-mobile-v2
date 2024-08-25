// ignore_for_file: file_names

import 'dart:async';
import 'package:sdm/models/update_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/approve_organization_repository.dart';

class ApproveOrganizationBloc {
  late ApproveOrganizationRepository _approveOrganizationRepository;
  StreamController? _approveOrganizationController;

  StreamSink<Response<UpdateOrganization>> get approveOrganizationSink =>
      _approveOrganizationController!.sink as StreamSink<Response<UpdateOrganization>>;
  Stream<Response<UpdateOrganization>> get approveOrganizationStream =>
      _approveOrganizationController!.stream as Stream<Response<UpdateOrganization>>;

  ApproveOrganizationBloc() {
    _approveOrganizationController = StreamController<Response<UpdateOrganization>>.broadcast();
    _approveOrganizationRepository = ApproveOrganizationRepository();
  }

  approveOrganization(String id, String username) async {
    if (_approveOrganizationController?.isClosed ?? true) return;
    approveOrganizationSink.add(Response.loading(''));
    try {
      UpdateOrganization res = await _approveOrganizationRepository.approveOrganization(id, username);
      if (_approveOrganizationController?.isClosed ?? true) return;
      approveOrganizationSink.add(Response.completed(res));
      print("APPROVE ORGANIZATION SUCCESS");
    } catch (e) {
      if (_approveOrganizationController?.isClosed ?? true) return;
      approveOrganizationSink.add(Response.error(e.toString()));
      print("APPROVE ORGANIZATION ERROR");
    }
  }

  dispose() {
    _approveOrganizationController?.close();
  }
}
