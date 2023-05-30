import 'package:flutter/foundation.dart';

class GlobalState with ChangeNotifier {
  String? _privateKey;

  String? get privateKey => _privateKey;

  void setPrivateKey(String privateKey) {
    _privateKey = privateKey;
    notifyListeners();
  }
}
