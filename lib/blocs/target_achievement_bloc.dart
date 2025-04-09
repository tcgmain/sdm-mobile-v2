import 'dart:async';
import 'package:sdm/models/target_achievement.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/target_achievement_repository.dart';

class TargetAchievementBloc {
  late TargetAchievementRepository _targetAchievementRepository;
  StreamController? _targetAchievementController;

  StreamSink<ResponseList<TargetAchievement>> get targetAchievementSink =>
      _targetAchievementController!.sink as StreamSink<ResponseList<TargetAchievement>>;
  Stream<ResponseList<TargetAchievement>> get targetAchievementStream =>
      _targetAchievementController!.stream as Stream<ResponseList<TargetAchievement>>;

  TargetAchievementBloc() {
    _targetAchievementController = StreamController<ResponseList<TargetAchievement>>.broadcast();
    _targetAchievementRepository = TargetAchievementRepository();
  }

  getTargetAchievement(user, year, month) async {
    targetAchievementSink.add(ResponseList.loading(''));
    try {
      List<TargetAchievement> res = await _targetAchievementRepository.getTargetAchievement(user, year, month);
      targetAchievementSink.add(ResponseList.completed(res));
      print("TARGET ACHIEVEMENT SUCCESS");
    } catch (e) {
      targetAchievementSink.add(ResponseList.error(e.toString()));
      print("TARGET ACHIEVEMENT ERROR $e");
    }
  }

  dispose() {
    _targetAchievementController?.close();
  }
}
