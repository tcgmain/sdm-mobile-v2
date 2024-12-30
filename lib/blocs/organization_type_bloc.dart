import 'dart:async';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/organization_type_repository.dart';

class OrganizationTypeBloc {
  late OrganizationTypeRepository _organizationTypeRepository;
  StreamController? _organizationTypeController;

  StreamSink<ResponseList<Organization>> get organizationTypeSink =>
      _organizationTypeController!.sink as StreamSink<ResponseList<Organization>>;
  Stream<ResponseList<Organization>> get organizationTypeStream =>
      _organizationTypeController!.stream as Stream<ResponseList<Organization>>;

  OrganizationTypeBloc() {
    _organizationTypeController = StreamController<ResponseList<Organization>>.broadcast();
    _organizationTypeRepository = OrganizationTypeRepository();
  }

  getOrganizationByType(String organizationTypeNummer) async {
    organizationTypeSink.add(ResponseList.loading(''));
    try {
      List<Organization> res = await _organizationTypeRepository.getOrganizationByType(organizationTypeNummer);
      organizationTypeSink.add(ResponseList.completed(res));
      print("ORGANIZATION BY TYPE SUCCESS");
    } catch (e) {
      organizationTypeSink.add(ResponseList.error(e.toString()));
      print("ORGANIZATION BY TYPE ERROR $e");
    }
  }


  dispose() {
    _organizationTypeController?.close();
  }
}
