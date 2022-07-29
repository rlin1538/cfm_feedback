import 'package:xml/xml.dart';

class XmlUtils {

  // 将阿里云返回的文件列表xml格式数据转换为字符串列表
  static parseXmlToList(String s) {
    final document = XmlDocument.parse(s);
    final keys = document.findAllElements("Key");
    List<String> list = [];
    for(var oneKey in keys) {
      list.add(oneKey.text);
    }

    return list;
  }
}