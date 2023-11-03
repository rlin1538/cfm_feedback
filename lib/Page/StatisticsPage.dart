import 'package:cfm_feedback/Model/CfmerModel.dart';
import 'package:cfm_feedback/Model/MissionController.dart';
import 'package:cfm_feedback/Model/VersionModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Common/Mission.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key, required this.missionController});

  final MissionController missionController;

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Mission> missions = [];
  bool isVisible = false;

  //const StatisticsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.watch<VersionModel>();
    missions = widget.missionController.missions;
    // _loadData(model);
    return Scaffold(
      appBar: AppBar(
        title: Text(model.version + "版本统计"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            icon:
                isVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            elevation: 6.0,
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              // side: BorderSide(
              //   color: Colors.grey,
              //   width: 1,
              // ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Text(
                        context.watch<CfmerModel>().name,
                        style: GoogleFonts.zcoolXiaoWei(
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "获得奖励总数",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                isVisible ? _getMyPay().toString() : "****",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "版本奖励总数",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                isVisible ? _getAllPay().toString() : "****",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 6.0,
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              // side: BorderSide(
              //   color: Colors.grey,
              //   width: 1,
              // ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Text(
                                  "完成任务数",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Text(
                                  _getMyFinished().toString(),
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Text(
                                  "总任务数",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Text(
                                  missions.length.toString(),
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                "专项测试",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                "${_getMyMainCount()}/${_getMainCount()}",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                "武器测试",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                "${_getMyWeaponCount()}/${_getWeaponCount()}",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                "其它测试",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                "${_getMyFinished() - _getMyMainCount() - _getMyWeaponCount()}/${missions.length - _getMainCount() - _getWeaponCount()}",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                "专项完成度",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                _getPercent(_getMyMainCount(), _getMainCount()),
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                "完成度",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                _getPercent(_getMyFinished(), missions.length),
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //elevation: 3.0,
          ),
          Card(
            elevation: 6.0,
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              // side: BorderSide(
              //   color: Colors.grey,
              //   width: 1,
              // ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    Text("  截图时请隐藏奖励数额"),
                  ],
                ),
                decoration: BoxDecoration(
                  //color: (Theme.of(context).colorScheme.brightness != Brightness.dark) ? Colors.orange[100] : Colors.black26,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                padding: EdgeInsets.all(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _loadData(VersionModel model) async {
  //   missions = await getMissions(model.version);
  // }

  int _getMainCount() {
    int sum = 0;
    for (int i = 0; i < missions.length; i++) {
      if (missions[i].content.startsWith("专项")) {
        sum++;
      }
    }
    return sum;
  }

  int _getMyMainCount() {
    int sum = 0;
    for (int i = 0; i < missions.length; i++) {
      if (missions[i].content.startsWith("专项") && missions[i].isFinished == 1) {
        sum++;
      }
    }
    return sum;
  }

  int _getWeaponCount() {
    int sum = 0;
    for (int i = 0; i < missions.length; i++) {
      if (missions[i].content.startsWith("武器")) {
        sum++;
      }
    }
    return sum;
  }

  int _getMyWeaponCount() {
    int sum = 0;
    for (int i = 0; i < missions.length; i++) {
      if (missions[i].content.startsWith("武器") && missions[i].isFinished == 1) {
        sum++;
      }
    }
    return sum;
  }

  int _getAllPay() {
    int sum = 0;
    for (int i = 0; i < missions.length; i++) {
      sum += missions[i].pay;
    }
    return sum;
  }

  int _getMyPay() {
    int sum = 0;
    for (int i = 0; i < missions.length; i++) {
      if (missions[i].isFinished == 1) {
        sum += missions[i].pay;
      }
    }
    return sum;
  }

  int _getMyFinished() {
    int sum = 0;
    for (int i = 0; i < missions.length; i++) {
      if (missions[i].isFinished == 1) {
        sum++;
      }
    }
    return sum;
  }

  String _getPercent(int a, int b) {
    double p = (a / b) * 100;
    return p.toStringAsFixed(2) + "%";
  }
}
