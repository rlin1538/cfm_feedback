import 'dart:io';

import 'package:cfm_feedback/Common/Joy.dart';
import 'package:cfm_feedback/Page/MyJoysPage.dart';
import 'package:cfm_feedback/Page/ViewJoy.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saf/saf.dart';

import '../Utils/FileUtils.dart';
import 'package:saf/src/storage_access_framework/api.dart' as safTool;

class JoyBackupPage extends StatefulWidget {
  const JoyBackupPage({Key? key}) : super(key: key);

  @override
  State<JoyBackupPage> createState() => _JoyBackupPageState();
}

class _JoyBackupPageState extends State<JoyBackupPage> {
  final Saf saf = Saf("Android/data/com.tencent.tmgp.cf/files/Assets4");
  final Saf safAlpha =
      Saf("Android/data/com.tencent.tmgp.cfalpha/files/Assets4");
  List<Joy> joys = <Joy>[];
  final joyNameController = TextEditingController();

  @override
  void initState() {
    _getJoyPath();
    super.initState();
  }

  @override
  void dispose() {
    saf.clearCache();
    safAlpha.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("键位备份"),
        actions: [
          IconButton(
            onPressed: () {
              _getMyJoys();
            },
            icon: Icon(Icons.videogame_asset),
          ),
          IconButton(
            onPressed: () {
              _getHelp();
            },
            icon: Icon(Icons.help),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () {
                  // TODO joys切换体验服
                  Fluttertoast.showToast(msg: "下次一定做");
                },
                child: Text("切换到体验服"),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              joys
                  .map((e) => ExpansionTile(
                        title:
                            ListTile(title: Text("${e.player}的键位${e.joyNum}")),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextButton(
                                    onPressed: () async {
                                      await _viewJoy(e, context);
                                    },
                                    child: Text("查看")),
                              ),
                              Expanded(
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return TextButton(
                                      onPressed: () {
                                        _replaceJoy(e);
                                      },
                                      child: Text("替换"));
                                }),
                              ),
                              Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              title: Text("输入键位名"),
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller:
                                                        joyNameController,
                                                    decoration: InputDecoration(
                                                        hintText: e.title,
                                                        border:
                                                            OutlineInputBorder()),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await _backupJoy(
                                                        e, context);
                                                  },
                                                  child: Text("确认"),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Text("备份")),
                              ),
                            ],
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _backupJoy(Joy e, BuildContext context) async {
    String joyName = joyNameController.text;
    if (joyName.isEmpty) joyName = e.title;
    File joyBackup = File("/storage/emulated/0/CFM/Joy/$joyName");
    var uri = FileUtils.pathToUri(
        "/storage/emulated/0/Android/data/com.tencent.tmgp.cf/files/Assets4");
    var file = await safTool.findFile(uri, e.title);
    final joyStream = file?.getContent(Uri.parse(
        safTool.makeUriString(path: "/storage/emulated/0/CFM/temp.json")));
    if (await joyBackup.exists()) {
      Fluttertoast.showToast(msg: "改键位名已存在");
    } else {
      final newFile = await joyBackup.create(recursive: true);
      await newFile.writeAsString(await streamToString(joyStream!));
      joyNameController.clear();
      Fluttertoast.showToast(msg: "已备份成功");
      Navigator.pop(context);
    }
  }

  Future<void> _viewJoy(Joy e, BuildContext context) async {
    var uri = FileUtils.pathToUri(
        "/storage/emulated/0/Android/data/com.tencent.tmgp.cf/files/Assets4");
    String joyName = e.title;
    var file = await safTool.findFile(uri, joyName);
    final joyStream = file?.getContent(Uri.parse(
        safTool.makeUriString(path: "/storage/emulated/0/CFM/temp.json")));

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewJoy(streamToString(joyStream!), e.title);
    }));
  }

  _getMyJoys() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MyJoysPage();
    }));
  }

  _getHelp() {
    showDialog(
        context: context,
        builder: (context) {
          return HelpDialog();
        });
  }

  _getJoyPath() async {
    bool? isGranted = await saf.getDirectoryPermission(isDynamic: false);
    if (isGranted != null && isGranted) {
      var filePath = await saf.getFilesPath();
      print(filePath);
      if (filePath != null) {
        for (var file in filePath) {
          String title = file.substring(file.lastIndexOf('/') + 1);
          if (title.startsWith("CustomJoySticksConfig")) {
            if (title == "CustomJoySticksConfig.json" ||
                title == "CustomJoySticksConfig_2.json" ||
                title == "CustomJoySticksConfig_3.json") {
              // 删除这个无用临时配置
              var uri = FileUtils.pathToUri(
                  "/storage/emulated/0/Android/data/com.tencent.tmgp.cf/files/Assets4");
              var file = await safTool.findFile(uri, title);
              if ((await file?.exists())!) {
                print(file?.name);
                await file?.delete();
              }
            } else {
              try {
                String tempNum = title.substring(
                    title.indexOf('_') + 1, title.lastIndexOf('_'));
                joys.add(Joy(
                    title,
                    int.parse(tempNum),
                    title.substring(
                        title.lastIndexOf('_') + 1, title.indexOf('.')),
                    file));
              } catch (e) {
                joys.add(Joy(
                    title,
                    1,
                    title.substring(title.indexOf('_') + 1, title.indexOf('.')),
                    file));
                print(e);
              }
            }
          }
        }
      }
    } else {
      // failed to get the permission
      Fluttertoast.showToast(msg: "权限获取失败");
    }
    joys.sort((a, b) => a.player.compareTo(b.player));
    setState(() {});
  }

  _replaceJoy(Joy target) {
    List<BackupJoy> joys = _getBackupJoys();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(joys[index].title),
                onTap: () async {
                  await showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("确认替换？"),
                      content: Text("将用${joys[index].title}替换${target.title}，确认继续吗？"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("取消")),
                        ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _replace(joys[index], target);
                            },
                            child: Text("确认")),
                      ],
                    );
                  });
                },
              );
            },
            itemCount: joys.length,
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    );
  }

  _getBackupJoys() {
    List<BackupJoy> joys = <BackupJoy>[];
    final joysPath = Directory("/storage/emulated/0/CFM/Joy");
    var joyFiles = joysPath.listSync();

    for (var file in joyFiles) {
      joys.add(BackupJoy(
          file.path.substring(file.path.lastIndexOf('/') + 1), file.path));
    }

    return joys;
  }

  _replace(BackupJoy source, Joy target) async {
    try {
      File s = File(source.path);
      var uri = FileUtils.pathToUri(
          "/storage/emulated/0/Android/data/com.tencent.tmgp.cf/files/Assets4");
      String joyName = target.title;
      var file = await safTool.findFile(uri, joyName);

      String sourceData = await s.readAsString();
      if ((await file?.exists())!) {
        print(file?.name);
        await file?.delete();
        print(await safTool.createFileAsString(uri,
            mimeType: "text/json", displayName: joyName, content: sourceData));
      }
      print(source.path + "=====>" + target.path);
      Fluttertoast.showToast(msg: "替换成功");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
  }

  Future<String> streamToString(Stream<String> stream) async {
    var sum = "";
    await for (final value in stream) {
      sum += value;
    }
    return sum;
  }
}

class HelpDialog extends StatelessWidget {
  const HelpDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("如何使用键位转移"),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              '1. 键位名称\n例:1614266881的键位1\n即:CustomJoySticksConfig_1614266881.json\n其中1614266881为你的游戏ID\n'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              '2. 转移步骤\n选择要备份的键位——>点击备份并重命名——>\n选择要替换的键位——>点击替换并从已备份的键位中选择——>\n替换成功并上号保存\n'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '3. 注意事项\n①如果上号后发现改错请不要点击保存，先退出游戏登录，再用Mt管理器到Android/data/com.tencent.tmgp.cf/files/Assets4目录下删掉所有键位文件(CustomJoySticksConfig开头)，然后重新登陆即可恢复\n②不保证软件的可靠性，请谨慎使用',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
