import 'dart:async';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/organization_info_repository.dart';

class OrganizationInfoBloc {
  late OrganizationInfoRepository _organizationInfoRepository;
  StreamController? _organizationInfoController;

  StreamSink<ResponseList<Organization>> get organizationInfoSink =>
      _organizationInfoController!.sink as StreamSink<ResponseList<Organization>>;
  Stream<ResponseList<Organization>> get organizationInfoStream =>
      _organizationInfoController!.stream as Stream<ResponseList<Organization>>;

  OrganizationInfoBloc() {
    _organizationInfoController = StreamController<ResponseList<Organization>>.broadcast();
    _organizationInfoRepository = OrganizationInfoRepository();
  }

  getOrganizationInfo(String nummer) async {
   
    organizationInfoSink.add(ResponseList.loading(''));
    try {
      List<Organization> res = await _organizationInfoRepository.getOrganizationInfo(nummer);
      organizationInfoSink.add(ResponseList.completed(res));

      print("ORGANIZATION INFO SUCCESS");
    } catch (e) {
      organizationInfoSink.add(ResponseList.error(e.toString()));
      print("ORGANIZATION INFO ERROR $e");
    }
  }

  dispose() {
    _organizationInfoController?.close();
  }
}
