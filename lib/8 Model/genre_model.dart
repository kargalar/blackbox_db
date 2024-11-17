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
}
