class GenreModel {
  GenreModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<GenreModel> fromJsonList(List<dynamic> jsonList) {
    List<GenreModel> list = [];
    for (var json in jsonList) {
      list.add(GenreModel.fromJson(json));
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
