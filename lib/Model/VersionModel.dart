import 'package:flutter/widgets.dart';

import '../Utils/SPUtils.dart';

class VersionModel extends ChangeNotifier {
  String _version = "";
  List<String> _versions = [];

  String get version => _version;

  set version(String value) {
    _version = value;
    SPUtils.saveStringToSP("Version", value);
    notifyListeners();
  }

  List<String> get versions => _versions;

  addVersion(String v) {
    _versions.add(v);
    SPUtils.saveStringListToSP("Versions", _versions);
    notifyListeners();
  }

  VersionModel(version, versions) {
    this._version = version;
    this._versions = versions;
  }
}
