import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saf/saf.dart';

import '../MoreFunction/WaterMarkPage.dart';
import 'JoyBackupPage.dart';
import 'package:url_launcher/url_launcher.dart';

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
            leading: Icon(Icons.swap_horizontal_circle_outlined),
            title: Text("赛事信息"),
            subtitle: Text("查看战队详细信息，竞猜情况"),
            onTap: () {
              Fluttertoast.showToast(msg: "暂未完成");
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (BuildContext context) {
              //       return JoyBackupPage();
              //     }));
            },
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
            leading: Icon(Icons.info_outline),
            title: Text("关于此应用"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "M组小工具",
                applicationVersion: "2.0.10",
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
