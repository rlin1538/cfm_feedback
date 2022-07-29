// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';
//
// class WaterMark {
//   static Future<ui.Image?> addTextToImage(AssetEntity image, String water) async {
//     var imgWidget = WaterMarkPage(water, image);
//     return await imgWidget.toImage();
//   }
// }
// class WaterMarkPage extends StatelessWidget {
//   String water;
//   AssetEntity image;
//   WaterMarkPage(this.water, this.image);
//
//   GlobalKey globalKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       key: globalKey,
//       child: Stack(
//         children: [
//           Text(water, style: TextStyle(fontSize: 10),),
//           AssetEntityImage(image),
//         ],
//       ),
//     );
//   }
//
//   Future<ui.Image?> toImage() async {
//     BuildContext? buildContext = globalKey.currentContext;
//
//     if (null != buildContext){
//       print(water);
//       RenderRepaintBoundary? boundary = buildContext.findRenderObject() as RenderRepaintBoundary;
//       ui.Image image = await boundary.toImage();
//       return image;
//     } else {
//       return null;
//     }
//   }
// }
