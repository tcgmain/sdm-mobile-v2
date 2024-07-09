import 'dart:async';
import 'package:sdm/models/route_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/route_organization_repository.dart';

class RouteOrganizationBloc {
  late RouteOrganizationRepository _routeOrganizationRepository;
  StreamController? _routeOrganizationController;

  StreamSink<ResponseList<RouteOrganization>> get routeOrganizationSink =>
      _routeOrganizationController!.sink as StreamSink<ResponseList<RouteOrganization>>;
  Stream<ResponseList<RouteOrganization>> get routeOrganizationStream =>
      _routeOrganizationController!.stream as Stream<ResponseList<RouteOrganization>>;

  RouteOrganizationBloc() {
    _routeOrganizationController = StreamController<ResponseList<RouteOrganization>>.broadcast();
    _routeOrganizationRepository = RouteOrganizationRepository();
  }

  //Getting organization response
  getRouteOrganization(String routeNummer) async {
    routeOrganizationSink.add(ResponseList.loading(''));
    try {
      List<RouteOrganization> res = await _routeOrganizationRepository.getRouteOrganization(routeNummer);
      routeOrganizationSink.add(ResponseList.completed(res));

      print("ROUTE ORGANIZATION SUCCESS");
    } catch (e) {
      routeOrganizationSink.add(ResponseList.error(e.toString()));
      print("ROUTE ORGANIZATION ERROR");
      print(e);
    }
  }

  dispose() {
    _routeOrganizationController?.close();
  }
}
