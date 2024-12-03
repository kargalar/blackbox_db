class CastModel {
  CastModel({
    required this.id,
    required this.profilePath,
    required this.name,
  });

  int id;
  String? profilePath;
  String name;

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'],
      profilePath: json['profile_path'],
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
      'profile_path': profilePath,
      'name': name,
    };
  }
}
