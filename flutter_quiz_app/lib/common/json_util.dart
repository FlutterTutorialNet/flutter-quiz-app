import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class JsonUtil {
  static Future<List<T>> loadFromJsonAsync<T>(
      String jsonAssetPath, Function jsonToObject) async {
    String data = await rootBundle.loadString(jsonAssetPath);
    var jsonResult = json.decode(data);
    List<T> items =
        List<T>.from(jsonResult.map((model) => jsonToObject(model)));
    return items;
  }

  static Future<List<T>> loadFromJsonStringAsync<T>(
      String jsonString, Function jsonToObject) async {
    var jsonResult = json.decode(jsonString);
    List<T> items =
        List<T>.from(jsonResult.map((model) => jsonToObject(model)));
    return items;
  }
}
