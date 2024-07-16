import 'dart:async';
import 'package:sdm/models/team.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/team_repository.dart';

class TeamBloc {
  late TeamRepository _teamRepository;
  StreamController? _teamController;

  StreamSink<ResponseList<Team>> get teamSink =>
      _teamController!.sink as StreamSink<ResponseList<Team>>;
  Stream<ResponseList<Team>> get teamStream =>
      _teamController!.stream as Stream<ResponseList<Team>>;

  TeamBloc() {
    _teamController = StreamController<ResponseList<Team>>.broadcast();
    _teamRepository = TeamRepository();
  }

  getTeamDetails(String username) async {
    teamSink.add(ResponseList.loading(''));
    try {
      List<Team> res = await _teamRepository.getTeamDetails(username);
      teamSink.add(ResponseList.completed(res));
     
      print("TEAM SUCCESS");
    } catch (e) {
      teamSink.add(ResponseList.error(e.toString()));
      print("TEAM ERROR");
      print(e);
    }
  }

  dispose() {
    _teamController?.close();
  }
}
