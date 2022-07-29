import 'dart:async';
import 'dart:ui' as ui;
import 'package:cfm_feedback/Utils/ImageUtils.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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
  double _currentSliderValue = 10;

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
            Slider(
              value: _currentSliderValue,
              divisions: 5,
              max: 30,
              onChanged: (v) {
                setState(() {
                  _currentSliderValue = v;
                });
              },
            ),
            Row(
              children: [

              ],
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
                        } else {
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
                        style: TextStyle(fontSize: 20+_currentSliderValue, color: currentColor),
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

  void _markImage(BuildContext context, ui.Image water,
      StreamController streamController) async {
    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(context,
          pickerConfig: const AssetPickerConfig(
              maxAssets: 9, requestType: RequestType.image));
      if (result != null) {
        Fluttertoast.showToast(msg: "开始打水印");
        ImageUtils.markImage(result, water, streamController)
            .then((value) => Fluttertoast.showToast(msg: "打印完毕"));
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
