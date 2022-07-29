// import 'package:flutter/material.dart';
//
// class StreamButton extends StatefulWidget {
//   StreamButton(this.function,{Key? key}) : super(key: key);
//
//   Function function;
//
//   @override
//   State<StreamButton> createState() => _StreamButtonState();
// }
//
// class _StreamButtonState extends State<StreamButton> {
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         // 请求
//         widget.function();
//
//       },
//       child: StreamBuilder(
//           stream: null,
//           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.none:
//                 print("");
//             }
//       }),
//     );
//   }
// }
