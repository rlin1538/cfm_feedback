import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:merge_images/merge_images.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:image/image.dart' as Package_img;

class ImageUtils {
  static Future<Image> mergeImage(
      List<AssetEntity> images, String imageName) async {
    List<Image> imageList = await assetsToImages(images);
    Image image = await ImagesMergeHelper.margeImages(imageList, fit: true);
    imageToFile(imageName: imageName, image: image);
    return image;
  }

  static Future<void> markImage(List<AssetEntity> images, Image water,
      StreamController streamController) async {
    List<Image> imageList = await assetsToImages(images);

    for (int i = 0; i < imageList.length; i++) {
      var img = await addTextToImage(imageList[i], water);
      imageToFile(imageName: images[i].title!, image: img!);
      if (!streamController.isClosed) streamController.sink.add(i + 1);
    }
  }

  static Future<List<Image>> assetsToImages(List<AssetEntity> images) async {
    List<Image> imageList = [];
    for (var i in images) {
      File file = (await i.file)!;
      Image temp = await ImagesMergeHelper.loadImageFromFile(file);
      imageList.add(temp);
    }
    return imageList;
  }

  // 压缩图片
  // 将 [file] 转为Uint8List
  static Future<Uint8List?> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1920,
      minHeight: 1080,
      quality: 50,
    );
    print(file.lengthSync());
    print(result?.length);
    return result;
  }

  static imageToFile({required String imageName, required Image image}) async {
    //File? file = await ImagesMergeHelper.imageToFile(image);
    //file?.copy("/storage/emulated/0/DCIM/CFM/$imageName.png");
    var imageBytes = await ImagesMergeHelper.imageToUint8List(image);
    final result = await ImageGallerySaver.saveImage(
      imageBytes!,
      quality: 100,
      name: imageName,
    );
    print(result);
  }

  static addTextToImage(Image image, Image water) async {
    Package_img.Decoder imgDecoder = Package_img.PngDecoder();
    Package_img.Encoder imgEncoder = Package_img.PngEncoder();
    var bytes = await ImagesMergeHelper.imageToUint8List(image);
    var bytes2 = await ImagesMergeHelper.imageToUint8List(water);

    Package_img.Image? img = imgDecoder.decodeImage(bytes!);
    Package_img.Image? imgWM = imgDecoder.decodeImage(bytes2!);

    //6Package_img.BitmapFont.fromFnt(fnt, page)
    var wateredImg = Package_img.drawImage(img!, imgWM!,
        dstX: 20,
        dstY: img.height - imgWM.height * 3 - 20,
        dstH: imgWM.height * 3,
        dstW: imgWM.width * 3,
        srcX: 0,
        srcY: 0,
        srcH: imgWM.height,
        srcW: imgWM.width);

    return ImagesMergeHelper.uint8ListToImage(
        Uint8List.fromList(imgEncoder.encodeImage(wateredImg)));
  }

  static Uint8List encode(String s) {
    var encodedString = utf8.encode(s);
    var encodedLength = encodedString.length;
    var data = ByteData(encodedLength + 4);
    data.setUint32(0, encodedLength, Endian.big);
    var bytes = data.buffer.asUint8List();
    bytes.setRange(4, encodedLength + 4, encodedString);
    return bytes;
  }
}
