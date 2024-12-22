class LanguageModel {
  LanguageModel({
    required this.id,
    required this.iso,
    required this.name,
  });

  int? id;
  String? iso;
  String? name;

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'],
      iso: json['iso_639_1'],
      name: json['english_name'] ?? json['name'],
    );
  }

  static List<LanguageModel> fromJsonList(List<dynamic> jsonList) {
    List<LanguageModel> list = [];
    for (var json in jsonList) {
      list.add(LanguageModel.fromJson(json));
    }
    return list;
  }
}
