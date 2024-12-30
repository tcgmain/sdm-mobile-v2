import 'dart:async';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/organization_approver_repository.dart';

class OrganizationApproverBloc {
  late OrganizationApproverRepository _organizationApproverRepository;
  StreamController? _organizationApproverController;

  StreamSink<ResponseList<Organization>> get organizationApproverSink =>
      _organizationApproverController!.sink as StreamSink<ResponseList<Organization>>;
  Stream<ResponseList<Organization>> get organizationApproverStream =>
      _organizationApproverController!.stream as Stream<ResponseList<Organization>>;

  OrganizationApproverBloc() {
    _organizationApproverController = StreamController<ResponseList<Organization>>.broadcast();
    _organizationApproverRepository = OrganizationApproverRepository();
  }

  getOrganizationByApprover(String userNummer, String isActive, String isApproved, String approverName) async {
    organizationApproverSink.add(ResponseList.loading(''));
    try {
      List<Organization> res =
          await _organizationApproverRepository.getOrganizationByApprover(userNummer, isActive, isApproved, approverName);
      organizationApproverSink.add(ResponseList.completed(res));
      print("ORGANIZATION BY APPROVER SUCCESS");
    } catch (e) {
      organizationApproverSink.add(ResponseList.error(e.toString()));
      print("ORGANIZATION BY APPROVER ERROR $e");
    }
  }


  dispose() {
    _organizationApproverController?.close();
  }
}
