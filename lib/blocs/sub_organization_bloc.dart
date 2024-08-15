import 'dart:async';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/sub_organization_repository.dart';

class SubOrganizationBloc {
  late SubOrganizationRepository _subOrganizationRepository;
  StreamController? _subOrganizationController;

  StreamSink<ResponseList<Organization>> get subOrganizationSink =>
      _subOrganizationController!.sink as StreamSink<ResponseList<Organization>>;
  Stream<ResponseList<Organization>> get subOrganizationStream =>
      _subOrganizationController!.stream as Stream<ResponseList<Organization>>;

  SubOrganizationBloc() {
    _subOrganizationController = StreamController<ResponseList<Organization>>.broadcast();
    _subOrganizationRepository = SubOrganizationRepository();
  }

  getSubOrganization(organizationNummer) async {
    subOrganizationSink.add(ResponseList.loading(''));
    try {
      List<Organization> res = await _subOrganizationRepository.getSubOrganization(organizationNummer);
      subOrganizationSink.add(ResponseList.completed(res));

      print("VISIT SUCCESS");
    } catch (e) {
      subOrganizationSink.add(ResponseList.error(e.toString()));
      print("VISIT ERROR $e");
    }
  }

  dispose() {
    _subOrganizationController?.close();
  }
}
