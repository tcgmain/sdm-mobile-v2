import 'dart:async';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/organization_repository.dart';

class OrganizationBloc {
  late OrganizationRepository _organizationRepository;
  StreamController? _organizationController;

  StreamSink<ResponseList<Organization>> get organizationSink =>
      _organizationController!.sink as StreamSink<ResponseList<Organization>>;
  Stream<ResponseList<Organization>> get organizationStream =>
      _organizationController!.stream as Stream<ResponseList<Organization>>;

  OrganizationBloc() {
    _organizationController = StreamController<ResponseList<Organization>>.broadcast();
    _organizationRepository = OrganizationRepository();
  }

  getOrganization(String userNummer, String isActive, String isApproved) async {
    organizationSink.add(ResponseList.loading(''));
    try {
      List<Organization> res = await _organizationRepository.getOrganization(userNummer, isActive, isApproved);
      organizationSink.add(ResponseList.completed(res));
      print("ORGANIZATION SUCCESS");
    } catch (e) {
      organizationSink.add(ResponseList.error(e.toString()));
      print("ORGANIZATION ERROR $e");
    }
  }

    getOrganizationByApprover(String userNummer, String isActive, String isApproved, String approverName) async {
    organizationSink.add(ResponseList.loading(''));
    try {
      List<Organization> res = await _organizationRepository.getOrganizationByApprover(userNummer, isActive, isApproved, approverName);
      organizationSink.add(ResponseList.completed(res));
      print("ORGANIZATION BY APPROVER SUCCESS");
    } catch (e) {
      organizationSink.add(ResponseList.error(e.toString()));
      print("ORGANIZATION BY APPROVER ERROR $e");
    }
  }

  getOrganizationByLocation(minLongitude, maxLongitude, minLatitude, maxLatitude) async {
    organizationSink.add(ResponseList.loading(''));
    try {
      List<Organization> res =
          await _organizationRepository.getOrganizationByLocation(minLongitude, maxLongitude, minLatitude, maxLatitude);
      organizationSink.add(ResponseList.completed(res));
      print("ORGANIZATION SUCCESS");
    } catch (e) {
      organizationSink.add(ResponseList.error(e.toString()));
      print("ORGANIZATION ERROR $e");
    }
  }

    getOrganizationByType(String organizationTypeNummer) async {
    organizationSink.add(ResponseList.loading(''));
    try {
      List<Organization> res = await _organizationRepository.getOrganizationByType(organizationTypeNummer);
      organizationSink.add(ResponseList.completed(res));
      print("ORGANIZATION SUCCESS");
    } catch (e) {
      organizationSink.add(ResponseList.error(e.toString()));
      print("ORGANIZATION ERROR $e");
    }
  }

  dispose() {
    _organizationController?.close();
  }
}
