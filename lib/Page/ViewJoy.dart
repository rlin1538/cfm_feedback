import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/rainbow.dart';

class ViewJoy extends StatelessWidget {
  final Future<String> joyFuture;
  final joyName;
  ViewJoy(this.joyFuture,this.joyName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          //centerTitle: true,
          title: Text(joyName),
          titleTextStyle: TextStyle(fontSize: 16),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<String>(
              future: joyFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("读取键位时出错");
                } else if (snapshot.hasData) {
                  String code = snapshot.data!;
                  return HighlightView(
                    code,
                    language: 'json',
                    theme: rainbowTheme,
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }

}
