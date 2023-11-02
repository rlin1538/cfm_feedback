import 'package:cfm_feedback/Model/CfmerModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NicknameCard extends StatelessWidget {
  NicknameCard({Key? key,this.elevation = 1.0, required this.model}) : super(key: key);

  final CfmerModel model;
  final double elevation;

  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = model.name;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: elevation,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(
                    maxHeight: 60,
                    maxWidth: 260
                ),
                child: Text(
                  model.name,
                  style: TextStyle(
                    fontSize: 36.0,
                  ),
                ),
              ),
              IconButton(
                alignment: Alignment.centerRight,
                onPressed: () {
                  showDialog(context: context, builder: (context) {
                    return SimpleDialog(
                      title: Text("修改昵称"),
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
                                  model.name = _nameController.text;
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(msg: "更改成功");
                                },
                                child: Text("确认")),
                          ],
                        )
                      ],
                    );
                  });
                },
                icon: Icon(Icons.edit),
              )
            ],
          ),
        ),
      ),
    );
  }
}
