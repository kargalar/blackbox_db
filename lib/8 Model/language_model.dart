class LanguageModel {
  LanguageModel({
    required this.iso,
    required this.name,
  });

  String iso;
  String name;

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      iso: json['iso_639_1'],
      name: json['english_name'],
    );
  }

  static List<LanguageModel> fromJsonList(List<dynamic> jsonList) {
    List<LanguageModel> list = [];
    for (var json in jsonList) {
      list.add(LanguageModel.fromJson(json));
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      'iso_639_1': iso,
      'english_name': name,
    };
  }
}
