import 'package:flutter/material.dart';

class InitStateModel extends ChangeNotifier {
  bool _isInit = false;    // 广告初始化标识
  String? _version;        // 广告sdk版本

  bool get isInit => _isInit;
  String? get version => _version;

  void setInit(bool value) {
    if (_isInit != value) {
      _isInit = value;
      notifyListeners();
    }
  }
  void setVersion(String value) {
    if (_version != value) {
      _version = value;
      notifyListeners();
    }
  }
}