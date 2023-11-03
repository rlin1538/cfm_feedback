import 'dart:async';

import 'package:cfm_feedback/Model/CfmerModel.dart';
import 'package:cfm_feedback/Model/MissionController.dart';
import 'package:cfm_feedback/Page/MisssionPage.dart';
import 'package:cfm_feedback/Widgets/SetNameDialog.dart';
import 'package:flutter/material.dart';
import 'package:cfm_feedback/Page/MorePage.dart';
import 'package:cfm_feedback/Utils/PermissionUtils.dart';
import 'package:cfm_feedback/Page/StatisticsPage.dart';
import 'package:provider/provider.dart';

import '../Common/Globals.dart';
import '../Widgets/HelpDialog.dart';

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
    PermissionUtils.requestStoragePermission();
    Timer(Duration(seconds: 1), () => showSomeDialog());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: null,
        builder: (context, snapshot) {
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
        });
  }

  showSomeDialog() async {
    final prefs = Globals.prefs;
    // 展示权限申请弹出
    // final isPermissionShowed = prefs.getBool("is_permission_dialog_showed");
    // if (! await Permission.manageExternalStorage.isGranted) {
    //   await showDialog(context: context, builder: (context) {
    //     return SimpleDialog(
    //       title: Text("存储权限申请"),
    //     );
    //   });
    //   //PermissionUtils.requestStoragePermission();
    // }
    // 首次启动展示昵称弹窗、帮助弹窗
    final isFirstLaunch = prefs.getBool("is_first_launch");
    if (isFirstLaunch == null || !isFirstLaunch) {
      showDialog(
          context: context,
          builder: (context) {
            return SetNameDialog(model: context.watch<CfmerModel>());
          }).then((value) => showDialog(
          context: context,
          builder: (context) {
            prefs.setBool("is_first_launch", true);
            return AppHelpDialog();
          }));
    }
  }
}
