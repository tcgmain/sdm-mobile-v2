import 'dart:async';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/organization_asignee_repository.dart';

class OrganizationAsigneeBloc {
  late OrganizationAsigneeRepository _organizationAsigneeRepository;
  StreamController? _organizationAsigneeController;

  StreamSink<ResponseList<Organization>> get organizationAsigneeSink =>
      _organizationAsigneeController!.sink as StreamSink<ResponseList<Organization>>;
  Stream<ResponseList<Organization>> get organizationAsigneeStream =>
      _organizationAsigneeController!.stream as Stream<ResponseList<Organization>>;

  OrganizationAsigneeBloc() {
    _organizationAsigneeController = StreamController<ResponseList<Organization>>.broadcast();
    _organizationAsigneeRepository = OrganizationAsigneeRepository();
  }

  getOrganization(String userNummer, String isActive, String isApproved) async {
    organizationAsigneeSink.add(ResponseList.loading(''));
    try {
      List<Organization> res = await _organizationAsigneeRepository.getOrganization(userNummer, isActive, isApproved);
      organizationAsigneeSink.add(ResponseList.completed(res));
      print("ORGANIZATION SUCCESS");
    } catch (e) {
      organizationAsigneeSink.add(ResponseList.error(e.toString()));
      print("ORGANIZATION ERROR $e");
    }
  }

  dispose() {
    _organizationAsigneeController?.close();
  }
}
