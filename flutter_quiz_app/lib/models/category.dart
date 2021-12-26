class Category {
  late int id;
  late String name;
  late String imagePath;

  Category(this.id, this.name, this.imagePath);

  Category.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    imagePath = json["imagePath"];
  }

  static jsonToObject(dynamic json) {
    return Category(json["id"], json["name"], json["imagePath"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["imagePath"] = imagePath;
    return map;
  }
}
