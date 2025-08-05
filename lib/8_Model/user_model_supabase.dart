class UserModel {
  UserModel({
    required this.id,
    this.authUserId,
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

  String id; // Changed to String for UUID
  String? authUserId; // Supabase auth user ID
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
        authUserId: json["auth_user_id"],
        username: json["username"],
        picturePath: json["picture_path"],
        password: json["user_password"], // Keep for compatibility
        bio: json["bio"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        isFollowed: json["is_followed"],
        totalWatchMovies: json["total_watched_movies"] != null ? (json["total_watched_movies"] is String ? int.parse(json["total_watched_movies"]) : json["total_watched_movies"]) : null,
        totalWatchTime: json["total_watch_time"] != null ? (json["total_watch_time"] is String ? int.parse(json["total_watch_time"]) : json["total_watch_time"]) : null,
        totalPlayedGames: json["total_played_games"] != null ? (json["total_played_games"] is String ? int.parse(json["total_played_games"]) : json["total_played_games"]) : null,
        totalPlayedTime: json["total_game_time"] != null ? (json["total_game_time"] is String ? int.parse(json["total_game_time"]) : json["total_game_time"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "auth_user_id": authUserId,
        "username": username,
        "picture_path": picturePath,
        "bio": bio,
        "email": email,
        "created_at": createdAt.toIso8601String(),
      };

  // Supabase-specific JSON conversion
  Map<String, dynamic> toSupabaseJson() => {
        if (id != 'new') "id": id,
        "auth_user_id": authUserId,
        "username": username,
        "picture_path": picturePath,
        "bio": bio,
        "email": email,
      };
}
