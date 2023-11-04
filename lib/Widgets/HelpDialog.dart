import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHelpDialog extends StatelessWidget {
  const AppHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: SimpleDialog(title: Text("开始使用M组小工具"), children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("1. 版本管理\n\t\t单击左上角标题切换任务版本，长按可以添加版本\n"),
                  Text(
                      "2. 订阅管理\n\t\t单击右下角按钮，输入订阅名称，点击订阅开始自动获取版本订阅，订阅后出现订阅更新按钮可以更新当前订阅\n"),
                  Text(
                      "3. 任务管理\n\t\t单击右下角按钮来添加任务，点击任务查看详情，点击左侧圆点标记完成，左滑删除，长按标记不想完成\n"),
                  Text("4. 统计信息\n\t\t切换到统计数据页面查看统计信息，需要先在更多功能页面填写昵称\n"),
                ],
              ),
              Text(
                "本软件及内容为内部人员自用，禁止外传\n",
                style: TextStyle(color: Colors.red),
              ),
              Text(
                "By M寒心",
                style: GoogleFonts.zhiMangXing(
                  textStyle: TextStyle(color: Colors.grey, fontSize: 28),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
