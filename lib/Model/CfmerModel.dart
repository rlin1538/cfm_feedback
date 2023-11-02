import 'package:cfm_feedback/Utils/SPUtils.dart';
import 'package:flutter/material.dart';

class CfmerModel extends ChangeNotifier {
  String _name = "M【监测】";
  TextEditingController _qq = TextEditingController();
  TextEditingController _phone = TextEditingController();


  String get name => _name;

  set name(String value) {
    _name = value;
    SPUtils.saveStringToSP("Name", value);
    notifyListeners();
  }

  TextEditingController get qq => _qq;

  setQQ(String value) {
    _qq.text = value;
    SPUtils.saveStringToSP("QQ", value);
    notifyListeners();
  }

  TextEditingController get phone => _phone;

  setPhone(String value) {
    _qq.text = value;
    SPUtils.saveStringToSP("Phone", value);
    notifyListeners();
  }

  CfmerModel(String? name, String? qq, String? phone) {
    if (name == null || name.isEmpty) name = "M【监测】";
    this._name = name;
    if (qq == null || qq.isEmpty) qq = "123";
    this._qq.text = qq;
    if (phone == null || phone.isEmpty) phone = "pixel3";
    this._phone.text = phone;
    }
}