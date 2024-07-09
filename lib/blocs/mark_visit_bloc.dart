import 'dart:async';
import 'package:sdm/models/mark_visit.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/mark_visit_repository.dart';

class MarkVisitBloc{
  late MarkVisitRepository _markVisitRepository;
  StreamController? _markVisitController;

  StreamSink<Response<MarkVisit>> get markVisitSink => _markVisitController!.sink as StreamSink<Response<MarkVisit>>;
  Stream<Response<MarkVisit>> get markVisitStream => _markVisitController!.stream as Stream<Response<MarkVisit>>;

  MarkVisitBloc() {
    _markVisitController = StreamController<Response<MarkVisit>>.broadcast();
    _markVisitRepository = MarkVisitRepository();
  }
  
  //Getting update visit response
  markVisit(String username, String organization,String route,String date,String time) async {
    markVisitSink.add(Response.loading(''));
    try {
      MarkVisit res = await _markVisitRepository.markVisit(username, organization,route,date,time);
      markVisitSink.add(Response.completed(res));
      print("VISIT UPDATE SUCCESS");
    } catch (e) {
      markVisitSink.add(Response.error(e.toString()));
      print("VISIT UPDATE ERROR");
    }
  }

  dispose() {
    _markVisitController?.close();
  }
}