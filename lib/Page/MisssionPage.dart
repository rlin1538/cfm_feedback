import 'dart:convert';
import 'dart:developer';

import 'package:cfm_feedback/Model/MissionController.dart';
import 'package:cfm_feedback/Model/VersionModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Common/Mission.dart';
import '../Utils/DbUtils.dart';

class MissionPage extends StatefulWidget {

  const MissionPage({super.key, required this.missionController});
  final MissionController missionController;

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  //List<Mission> widget.missionController.missions = [];
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  bool isSubscribed = false;
  late DateTime subscribeTime;
  String subscribeURL = "";

  late VersionModel model;

  bool isInitData = false;

  var _missionNameController = TextEditingController();
  var _missionContentController = TextEditingController();
  var _missionPayController = TextEditingController();
  var _missionClaimController = TextEditingController();
  var _missionDeadlineController = TextEditingController();
  var _missionUrlController = TextEditingController();

  Future<Null> _selectDate(
      BuildContext context, TextEditingController textEditingController,
      {bool format = false}) async {
    DateTime? _datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2030),
    );
    TimeOfDay? _timePicker = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_datePicker != null && _timePicker != null) {
      setState(() {
        _date = _datePicker;
        _time = _timePicker;
        if (format) {
          String str = DateTime(
            _date.year,
            _date.month,
            _date.day,
            _time.hour,
            _time.minute,
          ).toString();
          textEditingController.text = str.substring(0, str.length - 7);
        } else {
          textEditingController.text =
              "${_date.year}年${_date.month}月${_date.day}日 ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}";
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model = context.watch<VersionModel>();
    _loadData(model);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(model.version + "任务管理"),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    children: model.versions
                        .map((e) => InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              onTap: () async {
                                model.version = e;
                                //widget.missionController.missions = await getwidget.missionController.missions(model.version);
                                widget.missionController.loadData(model);
                                _saveData();
                                setState(() {});
                                Navigator.pop(context);
                              },
                            ))
                        .toList(),
                  );
                });
          },
          onLongPress: () async {
            HapticFeedback.vibrate();
            var verDate = await showDatePicker(
              context: context,
              initialDate: _date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2050),
            );
            if (verDate != null) {
              String tempDate = "${verDate.year}年${verDate.month}月";
              if (!model.versions!.contains(tempDate)) {
                setState(() {
                  model.addVersion(tempDate);
                });
                Fluttertoast.showToast(msg: "$tempDate已添加");
                await _saveData();
              } else {
                Fluttertoast.showToast(msg: "$tempDate已存在");
              }
            }
          },
        ),
        centerTitle: true,
        actions: [
          Visibility(
            child: IconButton(
              tooltip: "更新订阅",
              onPressed: () async {
                Fluttertoast.showToast(msg: "更新订阅中...");
                _printAllMission();
                try {
                  int count = await _subscribe();
                  Fluttertoast.showToast(msg: "更新了$count条任务");
                  //widget.missionController.missions = await getwidget.missionController.missions(model.version);
                  widget.missionController.loadData(model);
                  setState(() {});
                } catch (e) {
                  Fluttertoast.showToast(msg: "订阅异常");
                }
              },
              icon: Icon(Icons.cloud_download),
            ),
            visible: isSubscribed,
          ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) {
          //       return StatisticsPage(
          //           widget.missionController.missions, version, _nameValueController.text);
          //     }));
          //   },
          //   icon: Icon(Icons.insert_chart),
          //   tooltip: "查看统计",
          // ),
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    //_getClip();
                    return SimpleDialog(title: Text("开始使用"), children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("1. 版本管理\n\t\t单击左上角标题切换任务版本，长按可以添加版本\n"),
                                Text(
                                    "2. 任务管理\n\t\t单击右下角按钮来添加任务或订阅，点击任务查看详情，点击左侧圆点标记完成，左滑删除，订阅后出现订阅更新按钮可以更新当前订阅\n"),
                                Text(
                                    "3. 统计信息\n\t\t单击右上角统计按钮来查看统计信息，需要先在更多功能页面填写昵称\n"),
                              ],
                            ),
                            Text(
                              "本软件及内容为内部人员自用，禁止外传\n",
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(
                              "By M寒心",
                              style: GoogleFonts.zhiMangXing(
                                textStyle:
                                    TextStyle(color: Colors.grey, fontSize: 28),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  });
            },
            icon: Icon(Icons.help),
            tooltip: "帮助",
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          //widget.missionController.missions = await getwidget.missionController.missions(model.version);
          widget.missionController.loadData(model);
          setState(() {});
        },
        child: Scrollbar(
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(index.toString()),
                background: Container(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            size: 32,
                          ),
                        ],
                      ),
                    ],
                  ),
                  color: Colors.red[300],
                ),
                direction: DismissDirection.endToStart,
                dismissThresholds: {DismissDirection.endToStart: 0.2},
                confirmDismiss: (d) async {
                  return await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("删除任务"),
                          content: Text("是否要删除该任务？"),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("取消")),
                            TextButton(
                                onPressed: () async {
                                  setState(() {
                                    deleteMission(widget.missionController.missions[index].id);
                                    widget.missionController.missions.removeAt(index);
                                  });
                                  Navigator.of(context).pop(true);
                                },
                                child: Text("确认")),
                          ],
                        );
                      });
                  //return false;
                },
                onDismissed: (d) {
                  //TODO 修复删除任务时报错
                  // setState(() {
                  //   widget.missionController.missions[index].isFinished = !widget.missionController.missions[index].isFinished;
                  // });
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('${widget.missionController.missions[index].name} dismissed')));
                },
                child: ListTile(
                  leading: IconButton(
                    icon: _getFinishStatus(widget.missionController.missions[index].isFinished),
                    onPressed: () async {
                      setState(() {
                        if (widget.missionController.missions[index].isFinished == 1) {
                          widget.missionController.missions[index].isFinished = 0;
                        } else {
                          widget.missionController.missions[index].isFinished = 1;
                        }
                      });
                      await updateMission(widget.missionController.missions[index]);
                    },
                  ),
                  title: Text(widget.missionController.missions[index].name),
                  subtitle: Text(widget.missionController.missions[index].deadline +
                      "\n" +
                      widget.missionController.missions[index].content),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.missionController.missions[index].pay.toString()),
                    ],
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text("任务名称"),
                              subtitle: Text(widget.missionController.missions[index].name),
                            ),
                            ListTile(
                              title: Text("任务内容"),
                              subtitle: Text(widget.missionController.missions[index].content),
                            ),
                            ListTile(
                              title: Text("任务要求"),
                              subtitle: Text(widget.missionController.missions[index].claim),
                            ),
                            ListTile(
                              title: Text("任务奖励"),
                              subtitle: Text(widget.missionController.missions[index].pay.toString()),
                            ),
                            ListTile(
                              title: Text("截止日期"),
                              subtitle: Text(widget.missionController.missions[index].deadline),
                            ),
                            ListTile(
                              title: Text("问卷链接"),
                              subtitle: Text(
                                widget.missionController.missions[index].url,
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                Uri url = Uri.parse(widget.missionController.missions[index].url);
                                launchUrl(url);
                              },
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: OutlinedButton(
                            //           onPressed: () async {
                            //             if (model.name == "" ||(model.name ==
                            //                 "M【监测】")) {
                            //               Fluttertoast.showToast(
                            //                   msg: "请在更多页面填写群昵称！");
                            //             } else {
                            //               // await _getImage(
                            //               //     index, context);
                            //               Fluttertoast.showToast(
                            //                   msg: "该接口已弃用");
                            //             }
                            //           },
                            //           child: Text("查看图片"),
                            //         ),
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: OutlinedButton(
                            //           onPressed: () async {
                            //             if (_nameValueController.text ==
                            //                 "M【监测】") {
                            //               Fluttertoast.showToast(
                            //                   msg: "请在反馈文本页面填写群昵称！");
                            //             } else {
                            //               // await _uploadImage(
                            //               //     context, index);
                            //               Fluttertoast.showToast(
                            //                   msg: "此接口已弃用");
                            //             }
                            //           },
                            //           child: Text("上传截图"),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //     MainAxisAlignment.center,
                            //     children: [Text("截图上传测试中，不保证稳定性")],
                            //   ),
                            // )
                          ],
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                    );
                  },
                  onLongPress: () async {
                    setState(() {
                      if (widget.missionController.missions[index].isFinished == 2) {
                        widget.missionController.missions[index].isFinished = 0;
                      } else {
                        widget.missionController.missions[index].isFinished = 2;
                      }
                    });
                    widget.missionController.notifyMissionChange();
                    await updateMission(widget.missionController.missions[index]);
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 1,
            ),
            itemCount: widget.missionController.missions.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                _getClip();
                return SimpleDialog(
                  title: Text("添加任务"),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              size: 18,
                            ),
                            Text("  复制任务可自动填充"),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: (Theme.of(context).colorScheme.brightness !=
                                  Brightness.dark)
                              ? Colors.orange[100]
                              : Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "输入任务名称",
                          labelText: "任务名称/订阅名称",
                        ),
                        textInputAction: TextInputAction.next,
                        controller: _missionNameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "输入任务内容",
                          labelText: "任务内容",
                        ),
                        textInputAction: TextInputAction.next,
                        controller: _missionContentController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "输入任务要求",
                          labelText: "任务要求",
                        ),
                        textInputAction: TextInputAction.next,
                        controller: _missionClaimController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "输入任务截止日期",
                            labelText: "任务截止日期",
                            suffix: IconButton(
                              onPressed: () {
                                _selectDate(context, _missionDeadlineController,
                                    format: true);
                              },
                              icon: Icon(Icons.calendar_today),
                            )),
                        textInputAction: TextInputAction.next,
                        controller: _missionDeadlineController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "输入任务奖励",
                          labelText: "任务奖励",
                        ),
                        textInputAction: TextInputAction.next,
                        controller: _missionPayController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "输入问卷链接",
                          labelText: "问卷链接",
                        ),
                        textInputAction: TextInputAction.done,
                        controller: _missionUrlController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () async {
                                if (_missionNameController.text.isEmpty) {
                                  Fluttertoast.showToast(msg: "未填写订阅名");
                                } else {
                                  Response response;
                                  try {
                                    response = await Dio().get(
                                        'https://rlin1538.coding.net/api/user/rlin1538/project/cfm_subscribe/shared-depot/cfm_feedback_subscribe/git/blob/main/subscribe');
                                    //print(response.toString());
                                    Map<String, dynamic> jsonResp =
                                        jsonDecode(response.toString());
                                    // print(jsonResp["data"]["file"]
                                    //         ["data"]
                                    //     .toString());
                                    List<String> subscribe = jsonResp["data"]
                                            ["file"]["data"]
                                        .toString()
                                        .split('\n');
                                    for (int i = 0; i < subscribe.length; i++) {
                                      if (_missionNameController.text ==
                                          subscribe[i]) {
                                        setState(() {
                                          subscribeURL = subscribe[i + 1];
                                          isSubscribed = true;
                                          subscribeTime = DateTime.now();
                                        });
                                        await _saveData();
                                        await _subscribe();
                                        Fluttertoast.showToast(
                                            msg:
                                                "订阅：${_missionNameController.text}成功！");
                                        print(subscribeURL);
                                        break;
                                      }
                                      if (i == subscribe.length - 1) {
                                        Fluttertoast.showToast(msg: "没有该订阅！");
                                      }
                                    }
                                  } catch (e) {
                                    print(e);
                                    Fluttertoast.showToast(msg: "订阅异常！");
                                  }

                                  Navigator.pop(context);
                                }
                              },
                              child: Text("订阅")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("取消")),
                          TextButton(
                              onPressed: () async {
                                if (checkTextController()) {
                                  Fluttertoast.showToast(msg: "有内容未填写！");
                                } else {
                                  Mission m = Mission(
                                    id: _missionNameController.text.hashCode,
                                    name: _missionNameController.text,
                                    content: _missionContentController.text,
                                    pay: int.parse(_missionPayController.text),
                                    version: model.version,
                                    isFinished: 0,
                                    url: _missionUrlController.text,
                                    deadline: _missionDeadlineController.text,
                                    claim: _missionClaimController.text,
                                  );
                                  if (!checkContainMission(m)) {
                                    widget.missionController.missions.add(m);
                                    insertMission(m);
                                    Fluttertoast.showToast(
                                      msg: "添加成功",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    setState(() {});
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "${m.name}已存在！");
                                  }

                                  Navigator.pop(context);
                                }
                              },
                              child: Text("确认")),
                        ],
                      ),
                    )
                  ],
                );
              }).then((value) => setState(() {}));
        },
        heroTag: "other",
      ),
    );
  }

  // Future<void> _uploadImage(BuildContext context, int index) async {
  //   final List<AssetEntity>? result = await AssetPicker.pickAssets(context,
  //       pickerConfig: const AssetPickerConfig(
  //           maxAssets: 9, requestType: RequestType.image));
  //   if (result != null) {
  //     Fluttertoast.showToast(msg: "开始上传，请等待", toastLength: Toast.LENGTH_SHORT);
  //     //final images = await ImageUtils.assetsToImages(result);
  //
  //     for (int i = 0; i < result.length; i++) {
  //       final bytes = await ImageUtils.testCompressFile((await result[i]
  //           .file)!); //await ImagesMergeHelper.imageToUint8List(images[i]);
  //       await Client().putObject(
  //           bytes!,
  //           "$version/${widget.missionController.missions[index].name}/${_nameValueController.text}/" +
  //               result[i].title!);
  //       Fluttertoast.showToast(
  //           msg: "已上传完毕${i + 1}张", toastLength: Toast.LENGTH_SHORT);
  //     }
  //     Fluttertoast.showToast(msg: "上传完毕", toastLength: Toast.LENGTH_SHORT);
  //   }
  // }

  // Future<void> _getImage(int index, BuildContext context) async {
  //   final client = Client();
  //   Fluttertoast.showToast(msg: "获取图片中，请等待", toastLength: Toast.LENGTH_SHORT);
  //   final res = await client.listObjects(
  //       "$version/${widget.missionController.missions[index].name}/${_nameValueController.text}/");
  //   List<String> images = XmlUtils.parseXmlToList(res.data);
  //   if (images.isNotEmpty) {
  //     List<ImageProvider> imageProviders = [];
  //     for (String s in images) {
  //       imageProviders.add(Image.network(
  //         client.getObjectUrl(s),
  //         headers: await client.getHeaders(s),
  //       ).image);
  //     }
  //     MultiImageProvider multiImageProvider =
  //         MultiImageProvider(imageProviders);
  //     Fluttertoast.showToast(msg: "共${images.length}张图片");
  //     showImageViewerPager(context, multiImageProvider,
  //         useSafeArea: true, immersive: false);
  //   } else {
  //     Fluttertoast.showToast(msg: "没有图片");
  //   }
  // }

  // _getVideo(String videoName, BuildContext context) async {
  //   //createCFM();
  //   final List<AssetEntity>? result = await AssetPicker.pickAssets(context,
  //       pickerConfig: const AssetPickerConfig(
  //           maxAssets: 1, requestType: RequestType.video));
  //   (await result?.first.file)?.copy("/storage/emulated/0/DCIM/CFM/$videoName");
  // }

  Future<int> _subscribe() async {
    int count = 0;
    Response response;
    print("订阅地址是：$subscribeURL");
    response = await Dio().get(
      subscribeURL,
    );
    Map<String, dynamic> jsonResp = jsonDecode(response.toString());
    print("原始数据长度：" +
        jsonResp["data"]["file"]["data"].toString().length.toString());
    List<dynamic> maps =
        json.decode(jsonResp["data"]["file"]["data"].toString());

    List<Mission> lists = List.generate(maps.length, (i) {
      //print("正在处理：${maps[i]["id"]}");
      return Mission(
        id: maps[i]['id'],
        name: maps[i]['name'],
        content: maps[i]['content'],
        pay: maps[i]['pay'],
        version: maps[i]['version'],
        isFinished: maps[i]['isFinished'],
        claim: maps[i]['claim'],
        url: maps[i]['url'],
        deadline: maps[i]['deadline'],
      );
    });
    for (Mission m in lists) {
      //print("解析到任务：$m");
      if (await containMissions(m.id)) {
        continue;
      } else {
        widget.missionController.missions.add(m);
        await insertMission(m);
        count++;
      }
    }
    // 新版本直接添加并切换
    if (lists.isNotEmpty) {
      if (! model.versions.contains(lists[0].version)) {
        model.addVersion(lists[0].version);
        model.version = lists[0].version;
      }
    }

    return count;
  }

  _printAllMission() {
    String json = "";
    if (kDebugMode && widget.missionController.missions.isNotEmpty) {
      for (Mission s in widget.missionController.missions) {
        json = json + s.toJson() + ',';
        //print(s.toJson()+',');
      }
      json = json.substring(0, json.length - 1);
      json = '[' + json + ']';
      Clipboard.setData(ClipboardData(text: json));
      log(json);
    }
  }

  void _getClip() async {
    var s = await Clipboard.getData(Clipboard.kTextPlain);
    if (s != null) {
      if (s.text!.startsWith("任务名称")) {
        _getFormat(s.text!);
      }
    }
  }

  _getFormat(String s) {
    List<String> strlist = s.split('\n');
    for (String str in strlist) {
      if (str.startsWith("任务名称")) {
        _missionNameController.text = str.substring(str.indexOf('：') + 1);
      } else if (str.startsWith("测试内容")) {
        _missionContentController.text = str.substring(str.indexOf('：') + 1);
      } else if (str.startsWith("任务基础奖励")) {
        _missionPayController.text = str.substring(str.indexOf('：') + 1);
      } else if (str.startsWith("测试要求")) {
        _missionClaimController.text = str.substring(str.indexOf('：') + 1);
      } else if (str.startsWith("具体截止时间")) {
        try {
          int YY, MM, DD, HH, Mi;
          List<String> strTime =
              str.substring(str.indexOf('：') + 1).split(RegExp(' | '));
          //print(strTime);
          List<String> strDate = strTime[0].split('.');
          //print(strDate);
          YY = int.parse(strDate[0]);
          MM = int.parse(strDate[1]);
          DD = int.parse(strDate[2]);
          List<String> strT = strTime[strTime.length - 1].split(':');
          if (strT.length == 1) {
            strT = strTime[strTime.length - 1].split('：');
          }
          HH = int.parse(strT[0]);
          Mi = int.parse(strT[1]);
          var deadtime = DateTime(YY, MM, DD, HH, Mi);
          _missionDeadlineController.text =
              deadtime.toString().substring(0, deadtime.toString().length - 7);
        } catch (e) {
          Fluttertoast.showToast(msg: "时间解析错误，请手动选择");
          print(e);
        }
      } else if (str.startsWith("问卷链接")) {
        _missionUrlController.text = str.substring(str.indexOf('：') + 1);
      }
    }
  }

  _loadData(VersionModel model) async {
    if (!isInitData) {
      isInitData = true;
        var prefs = await SharedPreferences.getInstance();

      //widget.missionController.missions = await getwidget.missionController.missions(model.version);
      widget.missionController.loadData(model);
        if (prefs.getBool("isSubscribed") != null) {
          isSubscribed = prefs.getBool("isSubscribed")!;
        }
        if (prefs.getString("subscribeURL") != null) {
          subscribeURL = prefs.getString("subscribeURL")!;
        }
        if (isSubscribed) {
          try {
            print("进入自动订阅");
            int count = await _subscribe();
            Fluttertoast.showToast(msg: "更新了$count条任务");
            //widget.missionController.missions = await getwidget.missionController.missions(model.version);
            widget.missionController.loadData(model);
          } catch (e) {
            Fluttertoast.showToast(msg: "订阅异常");
          }
        }
      //widget.missionController.missions = await getwidget.missionController.missions(model.version);
      widget.missionController.loadData(model);
      setState(() {});
    }
  }

  _saveData() async {
    var prefs = await SharedPreferences.getInstance();
    // prefs.setString("Version", version);
    // prefs.setStringList("Versions", versions);
    prefs.setBool("isSubscribed", isSubscribed);
    prefs.setString("subscribeURL", subscribeURL);
  }

  bool checkContainMission(Mission m) {
    for (int i = 0; i < widget.missionController.missions.length; i++) {
      if (m.id == widget.missionController.missions[i].id) {
        return true;
      }
    }
    return false;
  }

  bool checkTextController() {
    bool err = false;
    if (_missionContentController.text.isEmpty) {
      err = true;
    }
    if (_missionNameController.text.isEmpty) {
      err = true;
    }
    if (_missionPayController.text.isEmpty) {
      err = true;
    }
    return err;
  }

  Widget _getFinishStatus(int isFinished) {
    switch (isFinished) {
      case 0:
        return Icon(Icons.radio_button_unchecked);
      case 1:
        return Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      case 2:
        return Icon(
          Icons.not_interested,
          color: Colors.red,
        );
    }
    return Icon(Icons.radio_button_unchecked);
  }
//合并截图
// void _mergeImage(String imageName, BuildContext context) async {
//   try {
//     final List<AssetEntity>? result = await AssetPicker.pickAssets(context,
//         pickerConfig: const AssetPickerConfig(
//             maxAssets: 9, requestType: RequestType.image));
//     if (result != null) {
//       await ImageUtils.mergeImage(result, imageName);
//       Fluttertoast.showToast(msg: "已保存为$imageName.png");
//     }
//   } catch (e) {
//     print(e);
//   }
// }
}
