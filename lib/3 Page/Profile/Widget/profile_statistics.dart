import 'package:blackbox_db/6%20Provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileStatistics extends StatelessWidget {
  const ProfileStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return // profile staristicts
        Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            Text(
              "${context.watch<ProfileProvider>().user!.totalWatchMovies ?? 0}",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Text("Movies Watched"),
          ],
        ),
        SizedBox(width: 30),
        Column(
          children: [
            Text(
              "${context.watch<ProfileProvider>().user!.totalWatchTime != null ? context.watch<ProfileProvider>().user!.totalWatchTime! ~/ 60 : 0}",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Text("Hours Watched"),
          ],
        ),
        SizedBox(width: 50),
        Column(
          children: [
            Text(
              "${context.watch<ProfileProvider>().user!.totalPlayedGames ?? 0}",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Text("Games Played"),
          ],
        ),
        SizedBox(width: 30),
        Column(
          children: [
            Text(
              "${context.watch<ProfileProvider>().user!.totalPlayedTime ?? 0}",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Text("Hours Played"),
          ],
        ),
      ],
    );
  }
}
