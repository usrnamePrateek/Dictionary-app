import 'package:flutter/services.dart';

class TextReceiver {
  static const platform = MethodChannel('text_channel');

  static Future<String?> getSelectedText() async {
    try {
      return await platform.invokeMethod('getSelectedText');
    } catch (e) {
      return null;
    }
  }
}
