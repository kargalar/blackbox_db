class CreatorModel {
  CreatorModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    return CreatorModel(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<CreatorModel> fromJsonList(List<dynamic> jsonList) {
    List<CreatorModel> list = [];
    for (var json in jsonList) {
      list.add(CreatorModel.fromJson(json));
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
