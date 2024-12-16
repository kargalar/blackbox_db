// TODO: filter content type list

import 'package:blackbox_db/8%20Model/user_model.dart';

bool showMovie = true;
bool showBook = true;
bool showGame = false;

UserModel user = UserModel(
  id: 2,
  username: "kargalar",
  email: "m.islam0422@gmail.com",
  password: "islam0422",
  bio: "alrem ipstum ar ames litum",
  createdAt: DateTime.now(),
);

// UserModel user = UserModel(
//   id: 2,
//   username: "Karamazov",
//   email: "kramazoval@gmail.com",
//   password: "asdwadqwfqwf",
//   bio: "Babam iyi adamdı ama hayat ona kötü davarandı.",
//   createdAt: DateTime.now().subtract(const Duration(days: 20)),
// );
