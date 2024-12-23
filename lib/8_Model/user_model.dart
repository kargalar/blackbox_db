class UserModel {
  UserModel({
    required this.id,
    required this.picturePath,
    required this.username,
    required this.password,
    required this.bio,
    required this.email,
    required this.createdAt,
    this.isFollowed,
    this.totalWatchMovies,
    this.totalWatchTime,
    this.totalPlayedGames,
    this.totalPlayedTime,
  });

  int id;
  String? picturePath;
  String username;
  String? password;
  String? bio;
  String? email;
  DateTime createdAt;
  bool? isFollowed;
  // movie statistics
  int? totalWatchMovies;
  int? totalWatchTime;
  // game statistics
  int? totalPlayedGames;
  int? totalPlayedTime;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        picturePath: json["picture_path"],
        password: json["user_password"],
        bio: json["bio"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        isFollowed: json["is_followed"],
        totalWatchMovies: json["total_watched_movies"] != null ? int.parse(json["total_watched_movies"]) : null,
        totalWatchTime: json["total_watch_time"] != null ? int.parse(json["total_watch_time"]) : null,
        totalPlayedGames: json["total_played_games"] != null ? int.parse(json["total_played_games"]) : null,
        totalPlayedTime: json["total_game_time"] != null ? int.parse(json["total_game_time"]) : null,
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
