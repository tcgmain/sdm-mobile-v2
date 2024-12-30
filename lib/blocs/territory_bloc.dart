import 'dart:async';
import 'package:sdm/models/territory.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/territory_repository.dart';

class TerritoryBloc {
  late TerritoryRepository _territoryRepository;
  StreamController? _territoryController;

  StreamSink<ResponseList<Territory>> get territorySink =>
      _territoryController!.sink as StreamSink<ResponseList<Territory>>;
  Stream<ResponseList<Territory>> get territoryStream =>
      _territoryController!.stream as Stream<ResponseList<Territory>>;

  TerritoryBloc() {
    _territoryController = StreamController<ResponseList<Territory>>.broadcast();
    _territoryRepository = TerritoryRepository();
  }

  getTerritory(String userNummer) async {
   
    territorySink.add(ResponseList.loading(''));
    try {
      List<Territory> res = await _territoryRepository.getTerritory(userNummer);
      territorySink.add(ResponseList.completed(res));

      print("TERRITORY SUCCESS");
    } catch (e) {
      territorySink.add(ResponseList.error(e.toString()));
      print("TERRITORY ERROR $e");
    }
  }

  dispose() {
    _territoryController?.close();
  }
}
