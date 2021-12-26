class Option {
  late String text;
  late bool isCorrect;
  Option(this.text, this.isCorrect);

  Option.fromJson(dynamic json) {
    text = json["text"];
    isCorrect = json["isCorrect"];
  }

  static jsonToObject(dynamic json) {
    return Option(json["text"], json["isCorrect"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["text"] = text;
    map["isCorrect"] = isCorrect;
    return map;
  }
}
