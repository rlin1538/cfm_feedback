import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future requestAllPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.storage,
      Permission.photos,
    ].request();

    if (await Permission.storage.isGranted) {
      print("文件权限申请通过");
    } else {
      print("文件权限申请失败");
    }

    if (await Permission.photos.isGranted) {
      print("相册权限申请通过");
    } else {
      print("相册权限申请失败");
    }
  }

  static Future requestStoragePermission() async {
    Map<Permission, PermissionStatus> permission = await [
      //Permission.storage,await Permission.storage.isGranted &&
      Permission.manageExternalStorage
      ].request();

    if (await Permission.manageExternalStorage.isGranted) {
      print("文件权限申请通过");
    } else {
      print("文件权限申请失败");
    }
  }
}
