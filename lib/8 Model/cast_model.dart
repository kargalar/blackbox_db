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
}
