import 'dart:ffi';

import 'package:cfm_feedback/Utils/SPUtils.dart';
import 'package:flutter/material.dart';

class CfmerModel extends ChangeNotifier {
  String _name = "M【监测】";
  TextEditingController _qq = TextEditingController();
  TextEditingController _phone = TextEditingController();
  bool _autoUnFinished = false;


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
    _phone.text = value;
    SPUtils.saveStringToSP("Phone", value);
    notifyListeners();
  }

  bool get autoUnFinished => _autoUnFinished;

  set autoUnFinished(bool value) {
    _autoUnFinished = value;
    SPUtils.saveBoolToSP("AutoUnFinished", value);
    notifyListeners();
  }

  CfmerModel(String? name, String? qq, String? phone,bool? autoUnFinished) {
    if (name == null || name.isEmpty) name = "M【监测】";
    this._name = name;
    if (qq == null || qq.isEmpty) qq = "123";
    this._qq.text = qq;
    if (phone == null || phone.isEmpty) phone = "pixel3";
    this._phone.text = phone;
    if (autoUnFinished == null) autoUnFinished = false;
    this._autoUnFinished = autoUnFinished;
    }
}