import 'dart:async';
import 'package:sdm/models/visit.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/visit_repository.dart';

class VisitBloc {
  late VisitRepository _visitRepository;
  StreamController? _visitController;

  StreamSink<ResponseList<Visit>> get visitSink => _visitController!.sink as StreamSink<ResponseList<Visit>>;
  Stream<ResponseList<Visit>> get visitStream => _visitController!.stream as Stream<ResponseList<Visit>>;

  VisitBloc() {
    _visitController = StreamController<ResponseList<Visit>>.broadcast();
    _visitRepository = VisitRepository();
  }

  //Getting visit response
  visit(String userNummer, String organizationNummer) async {
    visitSink.add(ResponseList.loading(''));
    try {
      List<Visit> res = await _visitRepository.getVisit(userNummer, organizationNummer);
      visitSink.add(ResponseList.completed(res));
      print("VISIT SUCCESS");
    } catch (e) {
      visitSink.add(ResponseList.error(e.toString()));
      print("VISIT ERROR");
      print(e);
    }
  }

  dispose() {
    _visitController?.close();
  }
}
