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

  CfmerModel(String name, String qq, String phone) {
   this._name = name;
   this._qq.text = qq;
   this._phone.text = phone;
  }
}