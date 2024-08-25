import 'dart:async';
import 'package:sdm/models/route_list.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/route_list_repository.dart';

class RouteListBloc {
  late RouteListRepository _routeListRepository;
  StreamController? _routeListController;

  StreamSink<ResponseList<RouteList>> get routeListSink =>
      _routeListController!.sink as StreamSink<ResponseList<RouteList>>;
  Stream<ResponseList<RouteList>> get routeListStream =>
      _routeListController!.stream as Stream<ResponseList<RouteList>>;

  RouteListBloc() {
    _routeListController = StreamController<ResponseList<RouteList>>.broadcast();
    _routeListRepository = RouteListRepository();
  }

  //Getting List response
  getRouteList(String routeNummer) async {
    routeListSink.add(ResponseList.loading(''));
    try {
      List<RouteList> res = await _routeListRepository.getRouteList(routeNummer);
      routeListSink.add(ResponseList.completed(res));

      print("ROUTE List SUCCESS");
    } catch (e) {
      routeListSink.add(ResponseList.error(e.toString()));
      print("ROUTE List ERROR");
      print(e);
    }
  }

  //Getting List response
  getRouteListWithoutTable(String routeNummer) async {
    routeListSink.add(ResponseList.loading(''));
    try {
      List<RouteList> res = await _routeListRepository.getRouteList(routeNummer);
      routeListSink.add(ResponseList.completed(res));

      print("ROUTE List SUCCESS");
    } catch (e) {
      routeListSink.add(ResponseList.error(e.toString()));
      print("ROUTE List ERROR");
      print(e);
    }
  }

  dispose() {
    _routeListController?.close();
  }
}
