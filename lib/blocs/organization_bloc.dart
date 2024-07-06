import 'dart:async';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/organization_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  getOrganization() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = (prefs.getString('username')).toString();

    organizationSink.add(ResponseList.loading(''));
    try {
      List<Organization> res = await _organizationRepository.getOrganization(username);
      organizationSink.add(ResponseList.completed(res));

      print("Visit SUCCESS");
    } catch (e) {
      organizationSink.add(ResponseList.error(e.toString()));
      print("Visit ERROR $e");
    }
  }

  dispose() {
    _organizationController?.close();
  }
}
