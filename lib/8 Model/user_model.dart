class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.bio,
    required this.email,
    required this.createdAt,
    this.isFollowed,
  });

  int id;
  String username;
  String? password;
  String? bio;
  String? email;
  DateTime createdAt;
  bool? isFollowed;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        password: json["user_password"],
        bio: json["bio"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        isFollowed: json["is_followed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "user_password": password,
        "bio": bio,
        "email": email,
        "created_at": createdAt.toIso8601String(),
      };
}
