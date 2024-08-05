import 'dart:async';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/pending_approval_organization_repository.dart';

class ApprovalOrganizationBloc {
  late ApprovalOrganizationRepository _approvalOrganizationRepository;
  StreamController? _approvalOrganizationController;

  StreamSink<ResponseList<Organization>> get approvalOrganizationSink =>
      _approvalOrganizationController!.sink as StreamSink<ResponseList<Organization>>;
  Stream<ResponseList<Organization>> get approvalOrganizationStream =>
      _approvalOrganizationController!.stream as Stream<ResponseList<Organization>>;

  ApprovalOrganizationBloc() {
    _approvalOrganizationController = StreamController<ResponseList<Organization>>.broadcast();
    _approvalOrganizationRepository = ApprovalOrganizationRepository();
  }

  getApprovalOrganization(String userNummer) async {
    approvalOrganizationSink.add(ResponseList.loading(''));
    try {
      List<Organization> res = await _approvalOrganizationRepository.getApprovalOrganization(userNummer);
      approvalOrganizationSink.add(ResponseList.completed(res));

      print("APPROVAL ORGANIZATION SUCCESS");
    } catch (e) {
      approvalOrganizationSink.add(ResponseList.error(e.toString()));
      print("APPROVAL ORGANIZATION ERROR $e");
    }
  }

  dispose() {
    _approvalOrganizationController?.close();
  }
}
