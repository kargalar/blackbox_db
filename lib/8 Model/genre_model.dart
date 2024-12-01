class GenreModel {
  GenreModel({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'],
      title: json['title'],
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
      'name': title,
    };
  }
}
