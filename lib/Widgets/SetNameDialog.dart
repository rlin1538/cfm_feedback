import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/CfmerModel.dart';

class SetNameDialog extends StatelessWidget {
  SetNameDialog({super.key, required this.model});

  final CfmerModel model;
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = model.name;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
      child: SimpleDialog(
        title: Text("填写昵称"),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "输入你的团内昵称",
                labelText: "团内昵称",
              ),
              textInputAction: TextInputAction.done,
              controller: _nameController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("取消")),
              TextButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "昵称为空！");
                    } else {
                      model.name = _nameController.text;
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "更改成功");
                    }
                  },
                  child: Text("确认")),
            ],
          )
        ],
      ),
    );
  }
}
