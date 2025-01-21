import 'dart:async';
import 'package:sdm/models/town.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/town_repository.dart';

class TownBloc {
  late TownRepository _townRepository;
  StreamController? _townController;

  StreamSink<ResponseList<Town>> get townSink =>
      _townController!.sink as StreamSink<ResponseList<Town>>;
  Stream<ResponseList<Town>> get townStream =>
      _townController!.stream as Stream<ResponseList<Town>>;

  TownBloc() {
    _townController = StreamController<ResponseList<Town>>.broadcast();
    _townRepository = TownRepository();
  }

  getTown(String minLon, String maxLon, String minLat, String maxLat) async {
   
    townSink.add(ResponseList.loading(''));
    try {
      List<Town> res = await _townRepository.getTown(minLon, maxLon, minLat, maxLat);
      townSink.add(ResponseList.completed(res));

      print("TOWN SUCCESS");
    } catch (e) {
      townSink.add(ResponseList.error(e.toString()));
      print("TOWN ERROR $e");
    }
  }

  dispose() {
    _townController?.close();
  }
}
