import 'dart:async';
import 'package:sdm/models/update_route.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/update_route_repository.dart';

class UpdateRouteBloc {
  late UpdateRouteRepository _updateRouteRepository;
  final StreamController<Response<UpdateRoute>> _updateRouteController =
      StreamController<Response<UpdateRoute>>.broadcast();

  StreamSink<Response<UpdateRoute>> get updateRouteSink => _updateRouteController.sink;
  Stream<Response<UpdateRoute>> get updateRouteStream => _updateRouteController.stream;

  UpdateRouteBloc() {
    _updateRouteRepository = UpdateRouteRepository();
  }

  updateRoute(String routeId, String organizationNummer) async {
    updateRouteSink.add(Response.loading('Loading...'));
    try {
      UpdateRoute res = await _updateRouteRepository.updateRoute(routeId, organizationNummer);
      updateRouteSink.add(Response.completed(res));
      print("ROUTE UPDATE SUCCESS");
    } catch (e) {
      updateRouteSink.add(Response.error(e.toString()));
      print("ROUTE UPDATE FAIL $e");
    }
  }

  dispose() {
    _updateRouteController.close();
  }
}
