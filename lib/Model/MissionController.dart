import 'package:flutter/cupertino.dart';

import '../Common/Mission.dart';
import '../Utils/DbUtils.dart';
import 'VersionModel.dart';

class MissionController extends ChangeNotifier {
  List<Mission> _missions = [];
  String filter = "";

  List<Mission> get missions {
    if (filter.isEmpty) {
      return _missions;
    } else {
      return _missions
          .where((element) => element.content.startsWith(filter))
          .toList();
    }
  }

  List<Mission> get allMission => _missions;

  set missions(List<Mission> value) {
    _missions = value;
    notifyListeners();
  }

  notifyMissionChange() {
    notifyListeners();
  }

  loadData(VersionModel model) async {
    _missions = await getMissions(model.version);
  }

  setMissionFilter(String s) {
    filter = s;
    notifyListeners();
  }
}
