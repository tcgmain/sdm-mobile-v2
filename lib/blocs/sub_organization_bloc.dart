import 'dart:async';
import 'package:sdm/models/organization.dart';
import 'package:sdm/models/sub_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/sub_organization_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubOrganizationBloc {
  late SubOrganizationRepository _subOrganizationRepository;
  StreamController? _subOrganizationController;

  StreamSink<ResponseList<SubOrganization>> get subOrganizationSink =>
      _subOrganizationController!.sink as StreamSink<ResponseList<SubOrganization>>;
  Stream<ResponseList<SubOrganization>> get subOrganizationStream =>
      _subOrganizationController!.stream as Stream<ResponseList<SubOrganization>>;

  SubOrganizationBloc() {
    _subOrganizationController = StreamController<ResponseList<SubOrganization>>.broadcast();
    _subOrganizationRepository = SubOrganizationRepository();
  }

  getSubOrganization(organizationNummer) async {
    subOrganizationSink.add(ResponseList.loading(''));
    try {
      List<SubOrganization> res = await _subOrganizationRepository.getSubOrganization(organizationNummer);
      subOrganizationSink.add(ResponseList.completed(res));

      print("Visit SUCCESS");
    } catch (e) {
      subOrganizationSink.add(ResponseList.error(e.toString()));
      print("Visit ERROR $e");
    }
  }

  dispose() {
    _subOrganizationController?.close();
  }
}
