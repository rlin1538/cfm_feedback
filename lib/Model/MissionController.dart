import 'package:flutter/cupertino.dart';

import '../Common/Mission.dart';
import '../Utils/DbUtils.dart';
import 'VersionModel.dart';

class MissionController extends ChangeNotifier {
  List<Mission> _missions = [];

  List<Mission> get missions => _missions;

  set missions(List<Mission> value) {
    _missions = value;
    notifyListeners();
  }

  notifyMissionChange() {
    notifyListeners();
  }

  loadData(VersionModel model) async {
    missions = await getMissions(model.version);
  }
}