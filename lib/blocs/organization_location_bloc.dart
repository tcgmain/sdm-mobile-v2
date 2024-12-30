import 'dart:async';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/organization_location_repository.dart';

class OrganizationLocationBloc {
  late OrganizationLocationRepository _organizationLocationRepository;
  StreamController? _organizationLocationController;

  StreamSink<ResponseList<Organization>> get organizationLocationSink =>
      _organizationLocationController!.sink as StreamSink<ResponseList<Organization>>;
  Stream<ResponseList<Organization>> get organizationLocationStream =>
      _organizationLocationController!.stream as Stream<ResponseList<Organization>>;

  OrganizationLocationBloc() {
    _organizationLocationController = StreamController<ResponseList<Organization>>.broadcast();
    _organizationLocationRepository = OrganizationLocationRepository();
  }

 getOrganizationByLocation(minLongitude, maxLongitude, minLatitude, maxLatitude) async {
    organizationLocationSink.add(ResponseList.loading(''));
    try {
      print("OOOOOOOOOOOOOOOOOOOOOOOO");
      List<Organization> res =
          await _organizationLocationRepository.getOrganizationByLocation(minLongitude, maxLongitude, minLatitude, maxLatitude);
      print("res.toString()");
      print(res.toString());
      organizationLocationSink.add(ResponseList.completed(res));
      print("ORGANIZATION BY LOCATION SUCCESS");
    } catch (e) {
      organizationLocationSink.add(ResponseList.error(e.toString()));
      print("ORGANIZATION BY LOCATION ERROR $e");
    }
  }

  dispose() {
    _organizationLocationController?.close();
  }
}
