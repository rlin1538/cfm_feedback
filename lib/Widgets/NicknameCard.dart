import 'package:cfm_feedback/Model/CfmerModel.dart';
import 'package:cfm_feedback/Widgets/SetNameDialog.dart';
import 'package:flutter/material.dart';

class NicknameCard extends StatelessWidget {
  NicknameCard({Key? key, this.elevation = 1.0, required this.model})
      : super(key: key);

  final CfmerModel model;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: elevation,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: 60, maxWidth: 260),
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
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SetNameDialog(
                          model: model,
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
