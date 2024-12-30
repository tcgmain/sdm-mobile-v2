import 'dart:async';
import 'package:sdm/models/Bdnotification.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/bdnotification_repository.dart';

class BdnotificationBlock {
  late BdnotificationRepository _bdnotificationRepository;
  StreamController<ResponseList<Bdnotification>>? _bdnotification_controller;

  // Sink to add data into the stream
  StreamSink<ResponseList<Bdnotification>> get bdnotificationSink =>
      _bdnotification_controller!.sink;

  // Stream to listen to data
  Stream<ResponseList<Bdnotification>> get bdnotificationStream =>
      _bdnotification_controller!.stream;

  BdnotificationBlock() {
    _bdnotification_controller =
        StreamController<ResponseList<Bdnotification>>.broadcast();
    _bdnotificationRepository = BdnotificationRepository();
  }

  getBdnotification(String yterritoryNummer) async {
    try {
      List<Bdnotification> res =
          await _bdnotificationRepository.getBdnotification(yterritoryNummer);
      if (_bdnotification_controller?.isClosed ?? true) return;
      bdnotificationSink.add(ResponseList.completed(res));
      print("Retrieved Birthday Details Successfully!");
    } catch (e) {
      if (_bdnotification_controller?.isClosed ?? true) return;
      bdnotificationSink.add(ResponseList.error(e.toString()));
      print("Birthday ERROR");
      print(e);
    }
  }

  dispose() {
    _bdnotification_controller?.close();
  }
}
