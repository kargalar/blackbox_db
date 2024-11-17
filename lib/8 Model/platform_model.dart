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
}
