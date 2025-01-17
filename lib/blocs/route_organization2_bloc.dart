import 'dart:async';
import 'package:sdm/models/route_organization2.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/route_organization2_repository.dart';

class RouteOrganization2Bloc {
  late RouteOrganization2Repository _routeOrganization2Repository;
  StreamController? _routeOrganization2Controller;

  StreamSink<ResponseList<RouteOrganization2>> get routeOrganization2Sink =>
      _routeOrganization2Controller!.sink as StreamSink<ResponseList<RouteOrganization2>>;
  Stream<ResponseList<RouteOrganization2>> get routeOrganization2Stream =>
      _routeOrganization2Controller!.stream as Stream<ResponseList<RouteOrganization2>>;

  RouteOrganization2Bloc() {
    _routeOrganization2Controller = StreamController<ResponseList<RouteOrganization2>>.broadcast();
    _routeOrganization2Repository = RouteOrganization2Repository();
  }

  //Getting organization response
  getRouteOrganization(String routeNummer, String date) async {
    routeOrganization2Sink.add(ResponseList.loading(''));
    try {
      List<RouteOrganization2> res = await _routeOrganization2Repository.getRouteOrganization2(routeNummer, date);
      routeOrganization2Sink.add(ResponseList.completed(res));

      print("ROUTE ORGANIZATION2 SUCCESS");
    } catch (e) {
      routeOrganization2Sink.add(ResponseList.error(e.toString()));
      print("ROUTE ORGANIZATION2 ERROR");
      print(e);
    }
  }

  dispose() {
    _routeOrganization2Controller?.close();
  }
}
