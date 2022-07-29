import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Common/Joy.dart';
import 'ViewJoy.dart';

class MyJoysPage extends StatefulWidget {
  const MyJoysPage({Key? key}) : super(key: key);

  @override
  State<MyJoysPage> createState() => _MyJoysPageState();
}

class _MyJoysPageState extends State<MyJoysPage> {
  List<Joy> joys = <Joy>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("已备份键位"),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getMyJoys(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Text("获取备份键位失败！");
            } else if (snapshot.hasData) {
              List<BackupJoy> joys = snapshot.data;
              if (joys.isEmpty) return Text("没有已备份的键位");
              return ListView.builder(
                itemBuilder: (context, i) {
                  return ExpansionTile(
                    title: Text(joys[i].title),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              _viewJoy(joys[i], context);
                            },
                            child: Text("查看"),
                          )),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              _renameJoy(joys[i]);
                            },
                            child: Text("重命名"),
                          )),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              _deleteJoy(joys[i]);
                            },
                            child: Text("删除"),
                          ))
                        ],
                      )
                    ],
                  );
                },
                itemCount: joys.length,
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  _getMyJoys() async {
    List<BackupJoy> joys = <BackupJoy>[];
    final joysPath = Directory("/storage/emulated/0/CFM/Joy");
    var joyFiles = joysPath.listSync();

    for (var file in joyFiles) {
      joys.add(BackupJoy(
          file.path.substring(file.path.lastIndexOf('/') + 1), file.path));
    }

    return joys;
  }

  Future<void> _viewJoy(BackupJoy e, BuildContext context) async {
    // var uri = FileUtils.pathToUri("/storage/emulated/0/Android/data/com.tencent.tmgp.cf/files/Assets4");
    // String joyName = e.title;
    // var file = await safTool.findFile(uri, joyName);
    // final joyStream = file?.getContent(Uri.parse(safTool.makeUriString(path: "/storage/emulated/0/CFM/temp.json")));
    File joyFile = File(e.path);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewJoy(joyFile.readAsString(), e.title);
    }));
  }

  _deleteJoy(BackupJoy joy) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("确认删除改键位备份吗？"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("取消")),
              ElevatedButton(
                  onPressed: () async {
                    File file = File(joy.path);
                    await file.delete();
                    Fluttertoast.showToast(msg: "已删除该键位备份");
                    Navigator.pop(context);
                    setState(() {
                      _getMyJoys();
                    });
                  },
                  child: Text("确认")),
            ],
          );
        });
  }

  _renameJoy(BackupJoy joy) async {
    final joyNameController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("输入键位名"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: joyNameController,
                  decoration: InputDecoration(
                      hintText: joy.title, border: OutlineInputBorder()),
                ),
              ),
              TextButton(
                onPressed: () async {
                  File file = File(joy.path);
                  String joyName = joyNameController.text;
                  if (joyName.isEmpty) joyName = joy.title;
                  try {
                    var path = file.path;
                    var lastSeparator =
                        path.lastIndexOf(Platform.pathSeparator);
                    var newPath =
                        path.substring(0, lastSeparator + 1) + joyName;
                    await file.rename(newPath);
                    Fluttertoast.showToast(msg: "重命名成功");
                    Navigator.pop(context);
                    setState(() {
                      _getMyJoys();
                    });
                  } catch (e) {
                    print(e);
                    Fluttertoast.showToast(msg: "重命名失败");
                  }
                },
                child: Text("确认"),
              )
            ],
          );
        });
  }
}
