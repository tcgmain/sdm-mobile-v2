import 'dart:async';
import 'package:sdm/models/route.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/route_repository.dart';

class RouteBloc {
  late RouteRepository _routeRepository;
  StreamController? _routeController;

  StreamSink<ResponseList<Routes>> get routeSink => _routeController!.sink as StreamSink<ResponseList<Routes>>;
  Stream<ResponseList<Routes>> get routeStream => _routeController!.stream as Stream<ResponseList<Routes>>;

  RouteBloc() {
    _routeController = StreamController<ResponseList<Routes>>.broadcast();
    _routeRepository = RouteRepository();
  }

  getRoute(String selectedDate, String userNummer) async {
    if (_routeController?.isClosed ?? true) return;
    routeSink.add(ResponseList.loading(''));
    try {
      List<Routes> res = await _routeRepository.getRoute(userNummer, selectedDate);
      if (_routeController?.isClosed ?? true) return;
      routeSink.add(ResponseList.completed(res));
      print("ROUTE SUCCESS");
    } catch (e) {
      if (_routeController?.isClosed ?? true) return;
      routeSink.add(ResponseList.error(e.toString()));
      print("ROUTE ERROR");
      print(e);
    }
  }

  dispose() {
    _routeController?.close();
  }
}
