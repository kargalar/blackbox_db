class PlatformModel {
  PlatformModel({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      id: json['id'],
      title: json['name'],
    );
  }

  static List<PlatformModel> fromJsonList(List<dynamic> jsonList) {
    List<PlatformModel> list = [];
    for (var json in jsonList) {
      list.add(PlatformModel.fromJson(json));
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
    };
  }
}
