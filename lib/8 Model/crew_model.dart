class CrewModel {
  CrewModel({
    required this.id,
    required this.profilePath,
    required this.name,
  });

  int id;
  String? profilePath;
  String name;

  factory CrewModel.fromJson(Map<String, dynamic> json) {
    return CrewModel(
      id: json['id'],
      profilePath: json['profile_path'],
      name: json['name'],
    );
  }

  static List<CrewModel> fromJsonList(List<dynamic> jsonList) {
    List<CrewModel> list = [];
    for (var json in jsonList) {
      list.add(CrewModel.fromJson(json));
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
