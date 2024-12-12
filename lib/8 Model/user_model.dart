class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.bio,
    required this.email,
    required this.createdAt,
  });

  int id;
  String username;
  String password;
  String bio;
  String email;
  DateTime createdAt;
}
