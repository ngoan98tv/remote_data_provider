import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JsonHelper {
  /// read json file from assets and decode it.
  static Future<dynamic> readAsset(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString);
  }
}
