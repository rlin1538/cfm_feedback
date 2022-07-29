class FileUtils {
  static Uri pathToUri(String path) {
    var paths = path.replaceAll("/storage/emulated/0/Android/data", "").split("/");
    String stringBuilder = "content://com.android.externalstorage.documents/tree/primary%3AAndroid%2Fdata";
    for (String p in paths) {
      if (p.length == 0) continue;
      stringBuilder+= "%2F$p";
    }
    return Uri.parse(stringBuilder.toString());
  }
}