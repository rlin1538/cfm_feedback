import 'package:cfm_feedback/Model/CfmerModel.dart';
import 'package:cfm_feedback/Page/FeedbackPage.dart';
import 'package:cfm_feedback/Widgets/NicknameCard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:saf/saf.dart';

import '../Widgets/HelpDialog.dart';
import 'JoyBackupPage.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatefulWidget {
  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  var _nameValueController = TextEditingController();
  String? _nameError;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CfmerModel>();
    _nameValueController.text = model.name;

    return Scaffold(
      appBar: AppBar(
        title: Text("更多功能"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Hero(
            tag: "cfm_name_card",
            child: NicknameCard(
              model: model,
              elevation: 0.0,
            ),
          ),
          // Card(
          //   child: ListTile(
          //     title: Text(widget.name),
          //   ),
          // ),
          // ListTile(
          //   leading: Icon(Icons.text_fields),
          //   title: Text("一键打水印"),
          //   subtitle: Text("多选图片，一键标上水印"),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (BuildContext context) {
          //       return WaterMarkPage(widget.name);
          //     }));
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.swap_horizontal_circle),
            title: Text("键位备份"),
            subtitle: Text("键位备份、转移到其他账号"),
            onTap: () {
              // 申请权限
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return JoyBackupPage();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.screen_search_desktop_rounded),
            title: Text("CFM自助工具"),
            subtitle: Text("查询道具流水、登陆流水、邮件流水等"),
            onTap: () {
              Uri url = Uri.parse("https://act.gbot.qq.com/gbot/act/a5e1d4e6f03094f5596b0dbe53fc1dd10/index.html");
              launchUrl(url);
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text("反馈模板"),
            subtitle: Text("反馈文本一键生成（已不再维护）"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return FeedbackPage(title: "反馈模板");
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.casino),
            title: Text("赛事信息"),
            subtitle: Text("查看战队详细信息，竞猜情况（等待施工）"),
            onTap: () {
              Fluttertoast.showToast(msg: "暂未完成");
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (BuildContext context) {
              //       return JoyBackupPage();
              //     }));
            },
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(Icons.notifications),
          //   title: Text("未完成任务角标"),
          //   trailing: Switch(
          //     onChanged: (bool value) {},
          //     value: false,
          //   ),
          // ),
          ListTile(
            leading: Icon(Icons.flag),
            title: Text("过期任务自动标记未完成"),
            trailing: Switch(
              onChanged: (bool value) {
                print("更改过期任务自动标记功能：$value");
                model.autoUnFinished = value;
              },
              value: model.autoUnFinished,
            ),
          ),
          ListTile(
            leading: Icon(Icons.cleaning_services_rounded),
            title: Text("清除/Android/data权限"),
            subtitle: Text("当log提取、键位备份失效时点此"),
            onTap: () async {
              // Saf saf = Saf("Android/data/com.tencent.tmgp.cf/cache/Cache/Log");
              // saf.releasePersistedPermission();
              // Saf saf2 =
              //     Saf("Android/data/com.tencent.tmgp.cfalpha/cache/Cache/Log");
              // saf2.releasePersistedPermission();
              await Saf.releasePersistedPermissions();

              Fluttertoast.showToast(msg: "释放成功，请重新授权");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text("请寒心喝可乐"),
            onTap: () async {
              final uri = Uri.parse(
                  "alipays://platformapi/startapp?appId=09999988&actionType=toAccount&goBack=NO&amount=3.00&userId=2088412913448152&memo=");
              try {
                await launchUrl(uri);
              } catch (e) {
                print(e);
                Fluttertoast.showToast(msg: "你还没有安装支付宝");
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("使用手册"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AppHelpDialog();
                  });
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("关于M组小工具"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "M组小工具",
                applicationVersion: "3.2.0",
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

  String? checkEmpty(String? text) {
    String? err;
    if (text == "")
      err = "未填写";
    else
      err = null;

    return err;
  }

// _saveName() async {
//   var prefs = await SharedPreferences.getInstance();
//   prefs.setString("Name", _nameValueController.text);
// }

// void _loadData() async {
//   var prefs = await SharedPreferences.getInstance();
//   if (prefs.getString("Name") != null) {
//     _nameValueController.text = prefs.getString("Name").toString();
//   } else {
//     _nameValueController.text = "M【监测】";
//   }
// }
}
