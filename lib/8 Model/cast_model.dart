class CastModel {
  CastModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<CastModel> fromJsonList(List<dynamic> jsonList) {
    List<CastModel> list = [];
    for (var json in jsonList) {
      list.add(CastModel.fromJson(json));
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
