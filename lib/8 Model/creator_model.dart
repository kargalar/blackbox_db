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
}
