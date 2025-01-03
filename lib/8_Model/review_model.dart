class ReviewModel {
  ReviewModel({
    required this.id,
    required this.picturePath,
    required this.userID,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  int id;
  String? picturePath;
  int userID;
  String userName;
  String text;
  DateTime createdAt;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      picturePath: json['picture_path'],
      userID: json['user_id'],
      userName: json['username'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static List<ReviewModel> fromJsonList(List<dynamic> jsonList) {
    List<ReviewModel> list = [];
    for (var json in jsonList) {
      list.add(ReviewModel.fromJson(json));
    }
    return list;
  }
}
