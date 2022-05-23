import 'dart:async';
import 'dart:ui' as ui;

import 'package:cfm_feedback/ImageUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saf/saf.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MorePage extends StatefulWidget {
  String name;

  MorePage(this.name);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("更多功能"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Card(
          //   child: ListTile(
          //     title: Text(widget.name),
          //   ),
          // ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text("一键打水印"),
            subtitle: Text("多选图片，一键标上水印"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return WaterMarkPage(widget.name);
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.swap_horizontal_circle_outlined),
            title: Text("一键转移键位(待实现)"),
            subtitle: Text("将正式服键位转移到体验服"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("未完成任务通知(待实现)"),
            trailing: Switch(
              onChanged: (bool value) {},
              value: false,
            ),
          ),
          ListTile(
            leading: Icon(Icons.cleaning_services_rounded),
            title: Text("清除/Android/data权限"),
            subtitle: Text("当log提取失效时点此"),
            onTap: () {
              Saf saf = Saf("Android/data/com.tencent.tmgp.cf/cache/Cache/Log");
              saf.releasePersistedPermission();
              Fluttertoast.showToast(msg: "释放成功，请重新授权");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text("(待实现)"),
          ),
          ListTile(
            leading: Icon(Icons.upload_file),
            title: Text("上传测试"),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("关于此应用"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "M组小工具",
                applicationVersion: "2.0.1",
                applicationLegalese: "@Rlin",
                applicationIcon: Image.asset(
                  "assets/cf_icon.png",
                  height: 80,
                  width: 80,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class WaterMarkPage extends StatefulWidget {
  String name;

  WaterMarkPage(this.name);

  @override
  State<WaterMarkPage> createState() => _WaterMarkPageState();
}

class _WaterMarkPageState extends State<WaterMarkPage> {
  var _nameValueController = TextEditingController();
  GlobalKey globalKey = GlobalKey();
  Color currentColor = Colors.black;
  Color pickerColor = Colors.black;
  final streamController = StreamController();

  @override
  void initState() {
    // TODO: implement initState
    _nameValueController.text = widget.name;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("一键打水印"),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("输入水印名，选择图片进行一键打印",
                      style: Theme.of(context).textTheme.headline6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _nameValueController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "M【监测】寒心",
                  labelText: "水印名",
                  border: OutlineInputBorder(),
                ),
                onChanged: (e) {
                  setState(() {});
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Pick a color!'),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: pickerColor,
                                    onColorChanged: (c) {
                                      pickerColor = c;
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('Got it'),
                                    onPressed: () {
                                      setState(
                                          () => currentColor = pickerColor);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text("选择颜色"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        ui.Image? waterMark = await _makeWaterMark();
                        //ImageUtils.imageToFile(imageName: "water", image: waterMark!);
                        _markImage(context, waterMark!, streamController);
                      },
                      child: Text("选择图片"),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: streamController.stream,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("None：无数据流");
                      case ConnectionState.waiting:
                        return Text("请选择图片");
                      case ConnectionState.active:
                        if (snapshot.hasError) {
                          return Text("Active：出错");
                        }
                        else {
                          return Text("已完成${snapshot.data}张水印");
                        }
                      case ConnectionState.done:
                        return Text("已打完所有水印");
                    }
                  },
                ),
              ),
            ),
            Divider(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("水印预览"),
                ),
                RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: [
                      Text(
                        _nameValueController.text,
                        style: TextStyle(fontSize: 30, color: currentColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  void _markImage(BuildContext context, ui.Image water, StreamController streamController) async {
    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(context,
          pickerConfig: const AssetPickerConfig(
              maxAssets: 9, requestType: RequestType.image));
      if (result != null) {
        Fluttertoast.showToast(msg: "开始打水印");
        ImageUtils.markImage(result, water, streamController).then((value) => Fluttertoast.showToast(msg: "打印完毕"));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<ui.Image?> _makeWaterMark() async {
    BuildContext? buildContext = globalKey.currentContext;

    if (null != buildContext) {
      RenderRepaintBoundary? boundary =
          buildContext.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      return image;
    } else {
      return null;
    }
  }
}
