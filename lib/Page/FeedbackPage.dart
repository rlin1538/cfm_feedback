import 'package:cfm_feedback/Widgets/NicknameCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:saf/saf.dart';
import 'dart:io';
import '../Common/NetworkStatus.dart';
import '../Model/CfmerModel.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key, required this.title});

  final String title;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String _serverValue = "正式服";
  var _nameValueController = TextEditingController();
  var _qqValueController = TextEditingController();
  String? _qqError;
  var _netWorkValueController = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  var _dateValueController = TextEditingController();
  var _phoneValueController = TextEditingController();
  String? _phoneError;
  String _bugValue = "地图BUG";
  String _modeValue = "PVP";
  String _degreeValue = "一般";
  var _descriptionController = TextEditingController();
  String? _descriptionError;
  String _appearValue = "偶现";
  var _stepController = TextEditingController();
  String? _stepError;
  var _positionController = TextEditingController();
  String? _positionError;
  var _videoValueController = TextEditingController();
  var _logValueController = TextEditingController();

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
    createCFM();
  }
  @override
  Widget build(BuildContext context) {
    final model = context.watch<CfmerModel>();
    _loadData(model);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Card(
            //     elevation: 0,
            //     shape: RoundedRectangleBorder(
            //       side: BorderSide(
            //         color: Theme.of(context).colorScheme.outline,
            //       ),
            //       borderRadius:
            //       const BorderRadius.all(Radius.circular(12)),
            //     ),
            //     child: Container(
            //       padding: EdgeInsets.all(16.0),
            //       child: Text(
            //         "先锋团M组专用，禁止外传！",
            //         style: GoogleFonts.maShanZheng(
            //           textStyle: TextStyle(
            //             color: Colors.red,
            //             fontSize: 20,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            //群昵称
            // Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Hero(
            //       tag: "cfmer_name",
            //       child: Text(
            //         model.name,
            //         style: TextStyle(
            //             fontSize: 24
            //         ),
            //       ),
            //     )
            // ),
            Hero(
              tag: "cfm_name_card",
              child: NicknameCard(model: model)
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 16.0,
              ),
              child: Row(
                children: [
                  Text(
                    "正式服/体验服",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: "正式服",
                  groupValue: _serverValue,
                  onChanged: (value) {
                    setState(() {
                      _serverValue = value.toString();
                    });
                  },
                ),
                Text("正式服"),
                Radio(
                  value: "万人服",
                  groupValue: _serverValue,
                  onChanged: (value) {
                    setState(() {
                      _serverValue = value.toString();
                    });
                  },
                ),
                Text("万人服"),
                Radio(
                  value: "千人服",
                  groupValue: _serverValue,
                  onChanged: (value) {
                    setState(() {
                      _serverValue = value.toString();
                    });
                  },
                ),
                Text("千人服"),
              ],
            ),
            Divider(),
//QQ号
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _qqValueController,
                onChanged: (v) {
                  if (_qqError != checkEmpty(v)) {
                    setState(() {
                      _qqError = checkEmpty(v);
                    });
                  }
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "输入QQ号",
                  labelText: "QQ",
                  border: OutlineInputBorder(),
                  errorText: _qqError,
                ),
              ),
            ),
            Divider(),
//网络状况
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _netWorkValueController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "选择网络状况",
                  labelText: "网络状况",
                  border: OutlineInputBorder(),
                  suffixIcon: PopupMenuButton<netWorkState>(
                    onSelected: (v) {
                      switch (v) {
                        case netWorkState.Mobile4G:
                          _netWorkValueController.text = "移动4G";
                          break;
                        case netWorkState.Unicom4G:
                          _netWorkValueController.text = "联通4G";
                          break;
                        case netWorkState.Dianxin4G:
                          _netWorkValueController.text = "电信4G";
                          break;
                        case netWorkState.Mobile5G:
                          _netWorkValueController.text = "移动5G";
                          break;
                        case netWorkState.Unicom5G:
                          _netWorkValueController.text = "联通5G";
                          break;
                        case netWorkState.Dianxin5G:
                          _netWorkValueController.text = "电信5G";
                          break;
                        case netWorkState.Wifi:
                          _netWorkValueController.text = "WiFi";
                          break;
                        default:
                      }
                    },
                    icon: Icon(Icons.arrow_drop_down),
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<netWorkState>>[
                        PopupMenuItem(
                          child: Text("移动4G"),
                          value: netWorkState.Mobile4G,
                        ),
                        PopupMenuItem(
                          child: Text("联通4G"),
                          value: netWorkState.Unicom4G,
                        ),
                        PopupMenuItem(
                          child: Text("电信4G"),
                          value: netWorkState.Dianxin4G,
                        ),
                        PopupMenuItem(
                          child: Text("移动5G"),
                          value: netWorkState.Mobile5G,
                        ),
                        PopupMenuItem(
                          child: Text("联通5G"),
                          value: netWorkState.Unicom5G,
                        ),
                        PopupMenuItem(
                          child: Text("电信5G"),
                          value: netWorkState.Dianxin5G,
                        ),
                        PopupMenuItem(
                          child: Text("WiFi"),
                          value: netWorkState.Wifi,
                        ),
                      ];
                    },
                  ),
                ),
              ),
            ),
            Divider(),
//时间
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _dateValueController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "选择发现时间",
                  labelText: "发现时间",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _selectDate(context, _dateValueController);
                      });
                    },
                    icon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            Divider(),
//手机型号
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _phoneValueController,
                onChanged: (v) {
                  if (_phoneError != checkEmpty(v)) {
                    setState(() {
                      _phoneError = checkEmpty(v);
                    });
                  }
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "如：小米11",
                  labelText: "手机型号",
                  errorText: _phoneError,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Divider(),
//BUG类型
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 16.0,
              ),
              child: Row(
                children: [
                  Text(
                    "Bug类型",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: "地图BUG",
                  groupValue: _bugValue,
                  onChanged: (value) {
                    setState(() {
                      _bugValue = value.toString();
                    });
                  },
                ),
                Text("地图BUG"),
                Radio(
                  value: "武器BUG",
                  groupValue: _bugValue,
                  onChanged: (value) {
                    setState(() {
                      _bugValue = value.toString();
                    });
                  },
                ),
                Text("武器BUG"),
                Radio(
                  value: "系统BUG",
                  groupValue: _bugValue,
                  onChanged: (value) {
                    setState(() {
                      _bugValue = value.toString();
                    });
                  },
                ),
                Text("系统BUG"),
              ],
            ),
            Divider(),
//BUG模式
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 16.0,
              ),
              child: Row(
                children: [
                  Text(
                    "Bug模式",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: "PVP",
                  groupValue: _modeValue,
                  onChanged: (value) {
                    setState(() {
                      _modeValue = value.toString();
                    });
                  },
                ),
                Text("PVP"),
                Radio(
                  value: "PVE",
                  groupValue: _modeValue,
                  onChanged: (value) {
                    setState(() {
                      _modeValue = value.toString();
                    });
                  },
                ),
                Text("PVE"),
                Radio(
                  value: "其他",
                  groupValue: _modeValue,
                  onChanged: (value) {
                    setState(() {
                      _modeValue = value.toString();
                    });
                  },
                ),
                Text("其他"),
              ],
            ),
            Divider(),
//BUG严重程度
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 16.0,
              ),
              child: Row(
                children: [
                  Text(
                    "Bug严重程度",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
// Radio(
//   value: "可忽略",
//   groupValue: _degreeValue,
//   onChanged: (value) {
//     setState(() {
//       _degreeValue = value.toString();
//     });
//   },
// ),
// Text("可忽略"),
                Radio(
                  value: "一般",
                  groupValue: _degreeValue,
                  onChanged: (value) {
                    setState(() {
                      _degreeValue = value.toString();
                    });
                  },
                ),
                Text("一般"),
                Radio(
                  value: "严重",
                  groupValue: _degreeValue,
                  onChanged: (value) {
                    setState(() {
                      _degreeValue = value.toString();
                    });
                  },
                ),
                Text("严重"),
                Radio(
                  value: "致命",
                  groupValue: _degreeValue,
                  onChanged: (value) {
                    setState(() {
                      _degreeValue = value.toString();
                    });
                  },
                ),
                Text("致命"),
              ],
            ),
            Divider(),
//BUG问题描述
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _descriptionController,
                onChanged: (v) {
                  if (_descriptionError != checkEmpty(v)) {
                    setState(() {
                      _descriptionError = checkEmpty(v);
                    });
                  }
                },
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "描述此bug发生的具体情况",
                  labelText: "BUG问题描述",
                  errorText: _descriptionError,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Divider(),
//BUG出现情况
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 16.0,
              ),
              child: Row(
                children: [
                  Text(
                    "BUG出现情况",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: "重现",
                  groupValue: _appearValue,
                  onChanged: (value) {
                    setState(() {
                      _appearValue = value.toString();
                    });
                  },
                ),
                Text("重现"),
                Radio(
                  value: "偶现",
                  groupValue: _appearValue,
                  onChanged: (value) {
                    setState(() {
                      _appearValue = value.toString();
                    });
                  },
                ),
                Text("偶现"),
              ],
            ),
            Divider(),
//BUG重现步骤
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _stepController,
                onChanged: (v) {
                  if (_stepError != checkEmpty(v)) {
                    setState(() {
                      _stepError = checkEmpty(v);
                    });
                  }
                },
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: _appearValue == "重现"
                      ? "填写详细出现步骤"
                      : "填写大概率再次出现此问题的步骤",
                  labelText: "BUG重现步骤",
                  errorText: _stepError,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Divider(),
//BUG出现位置
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _positionController,
                onChanged: (v) {
                  if (_positionError != checkEmpty(v)) {
                    setState(() {
                      _positionError = checkEmpty(v);
                    });
                  }
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "BUG在哪张地图哪个位置,非地图bug可填无",
                  labelText: "BUG出现位置",
                  errorText: _positionError,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Divider(),
//视频ID
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _videoValueController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "填写录制BUG的视频文件名，没有不填",
                  labelText: "视频id",
                  border: OutlineInputBorder(),
// suffixIcon: IconButton(
//   icon: Icon(Icons.input),
//   onPressed: () {
//     _videoValueController.text =
//         "${_nameValueController.text} ${_time.hour.toString().padLeft(2, '0')}${_time.minute.toString().padLeft(2, '0')}.mp4";
//     _getVideo(_videoValueController.text, context);
//   },
// ),
                ),
              ),
            ),
            Divider(),
//LogID
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                minLines: 1,
                maxLines: 3,
                controller: _logValueController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "填写Log文件名，没有不填",
                  labelText: "Log id",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.input),
                    onPressed: () {
                      _getLog(!_serverValue.contains("正式服"), context);
                    },
                  ),
                ),
              ),
            ),
// Divider(),
// Padding(
//   padding: EdgeInsets.all(16.0),
//   child: OutlinedButton(
//     onPressed: () {
//       _mergeImage(
//           "${_nameValueController.text} ${_time.hour.toString().padLeft(2, '0')}${_time.minute.toString().padLeft(2, '0')}",
//           context);
//     },
//     child: Text("图片拼接"),
//   ),
// ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "检查信息后按右下角的按钮进行复制\n视频位于/Sdcard/DCIM/CFM\n图片位于/Sdcard/Picture\nLog文件位于/Sdcard/CFM/log\n\tBy M组寒心",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 48,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (checkAllEmpty()) {
            Fluttertoast.showToast(msg: "有必填项未填写");
            return;
          }
          if (_videoValueController.text == "")
            _videoValueController.text = "无";
          if (_logValueController.text == "")
            _logValueController.text = "无";
          _saveData(model);
          String feedback = """$_serverValue
${_nameValueController.text}
${_qqValueController.text}
${_netWorkValueController.text}
${_dateValueController.text}
${_phoneValueController.text}
$_bugValue
$_modeValue
$_degreeValue
${_descriptionController.text}
$_appearValue
${_stepController.text}
${_positionController.text}
${_videoValueController.text}
${_logValueController.text}""";
          Clipboard.setData(ClipboardData(text: feedback));
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('已复制以下内容'),
              content: Text(feedback),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, '取消'),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
/*const url = 'tel';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }*/
                    Navigator.pop(context, '好的');
                  },
                  child: const Text('好的'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.file_copy),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _loadData(CfmerModel model) async {
    // var prefs = await SharedPreferences.getInstance();
    // if (prefs.getString("Name") != null) {
    //   _nameValueController.text = prefs.getString("Name").toString();
    // } else {
    //   _nameValueController.text = "M【监测】";
    // }
    // if (prefs.getString("QQ") != null) {
    //   _qqValueController.text = prefs.getString("QQ").toString();
    //   print(prefs.getString("QQ").toString());
    // }
    // if (prefs.getString("Phone") != null) {
    //   _phoneValueController.text = prefs.getString("Phone").toString();
    // }
    _nameValueController.text = model.name;
    _qqValueController = model.qq;
    _phoneValueController = model.phone;
    _dateValueController.text =
    "${_date.year}年${_date.month}月${_date.day}日 ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}";
  }

  _getLog(bool isAlpha, BuildContext context) async {
    //createCFM();
    String logPath;
    if (isAlpha) {
      logPath = "Android/data/com.tencent.tmgp.cfalpha/cache/Cache/Log";
    } else {
      logPath = "Android/data/com.tencent.tmgp.cf/cache/Cache/Log";
    }
    Saf saf = Saf(logPath);

    bool? isGranted = await saf.getDirectoryPermission(isDynamic: false);
    if (isGranted != null && isGranted) {
      var cachedFilesPath = await saf.cache();
      if (cachedFilesPath != null) {
        await showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("选择一个log文件"),
                children: [
                  Container(
                    height: 400,
                    width: 300,
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          String title = cachedFilesPath[index].substring(
                              cachedFilesPath[index].lastIndexOf('/') + 1);
                          return ListTile(
                            title: Text(title),
                            onTap: () {
                              File file = File(cachedFilesPath[index]);
                              String logName =
                                  "${_nameValueController.text} ${_qqValueController.text} ${_descriptionController.text} $title";
                              file.copy("/storage/emulated/0/CFM/log/$logName");
                              _logValueController.text = logName;
                              Navigator.pop(context);
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int i) =>
                            Divider(),
                        itemCount: cachedFilesPath.length),
                  )
                ],
              );
            });
      }
    } else {
      // failed to get the permission
      Fluttertoast.showToast(msg: "权限获取失败");
    }
    saf.clearCache();
  }

  Future<void> createCFM() async {
    Directory cfm = Directory("/storage/emulated/0/CFM");
    if (!(await cfm.exists())) {
      cfm.create();
      Directory cfmLog = Directory("/storage/emulated/0/CFM/log");
      Directory cfmPicture = Directory("/storage/emulated/0/CFM/picture");
      cfmLog.create();
      cfmPicture.create();
    }
    Directory cfmJoy = Directory("/storage/emulated/0/CFM/joy");
    if (!(await cfmJoy.exists())) {
      cfmJoy.create();
    }
    Directory cfmVideo = Directory("/storage/emulated/0/DCIM/CFM");
    if (!(await cfmVideo.exists())) {
      cfmVideo.create();
    }
  }

  String? checkEmpty(String? text) {
    String? err;
    if (text == "")
      err = "未填写";
    else
      err = null;

    return err;
  }

  bool checkAllEmpty() {
    if (checkEmpty(_qqValueController.text) != null) {
      setState(() {
        _qqError = "未填写";
      });
      return true;
    }
    if (checkEmpty(_phoneValueController.text) != null) {
      setState(() {
        _phoneError = "未填写";
      });
      return true;
    }
    if (checkEmpty(_descriptionController.text) != null) {
      setState(() {
        _descriptionError = "未填写";
      });
      return true;
    }
    if (checkEmpty(_stepController.text) != null) {
      setState(() {
        _stepError = "未填写";
      });
      return true;
    }
    if (checkEmpty(_positionController.text) != null) {
      setState(() {
        _positionError = "未填写";
      });
      return true;
    }
    return false;
  }

  // 数据持久化
  // _saveName() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   prefs.setString("Name", _nameValueController.text);
  // }
  _saveData(CfmerModel model) async {
    // var prefs = await SharedPreferences.getInstance();
    // prefs.setString("Name", _nameValueController.text);
    // prefs.setString("QQ", _qqValueController.text);
    // prefs.setString("Phone", _phoneValueController.text);
    model.setQQ(_qqValueController.text);
    model.setPhone(_phoneValueController.text);
  }
}
