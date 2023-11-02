import 'package:cfm_feedback/Model/MissionController.dart';
import 'package:cfm_feedback/Page/MisssionPage.dart';
import 'package:flutter/material.dart';
import 'package:cfm_feedback/Page/MorePage.dart';
import 'package:cfm_feedback/Utils/PermissionUtils.dart';
import 'package:cfm_feedback/Page/StatisticsPage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common/Mission.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  final missionController = MissionController();

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    PermissionUtils.requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: IndexedStack(
          index: currentIndex,
          children: [
            MissionPage(missionController: missionController),
            StatisticsPage(missionController: missionController),
            MorePage(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() {
          currentIndex = index;
        }),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.table_rows),
            label: "任务管理",
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: "统计数据",
          ),
          NavigationDestination(
            icon: Icon(Icons.more),
            label: "更多功能",
          ),
        ],
        height: 70,
      ),
    );
  }
}
