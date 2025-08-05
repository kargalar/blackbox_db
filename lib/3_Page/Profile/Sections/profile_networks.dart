import 'package:blackbox_db/2_General/Widget/profile_picture.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:flutter/material.dart';

class ProfileNetworks extends StatefulWidget {
  const ProfileNetworks({super.key});

  @override
  State<ProfileNetworks> createState() => _ProfileNetworksState();
}

class _ProfileNetworksState extends State<ProfileNetworks> {
  // follower list
  List<Map<String, dynamic>> followers = [];
  // following list
  List<Map<String, dynamic>> following = [];

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Followed',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: following.length,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      ProfilePicture(
                        imageUrl: following[index]['picture_path'],
                        userId: following[index]['id'],
                      ),
                      SizedBox(width: 10),
                      Text(
                        following[index]['username'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Followers',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: followers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      ProfilePicture(
                        imageUrl: followers[index]['picture_path'],
                        userId: followers[index]['id'],
                      ),
                      SizedBox(width: 10),
                      Text(
                        followers[index]['username'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void getData() async {
    followers = await MigrationService().getFollowers(userId: ProfileProvider().user!.id);
    following = await MigrationService().getFollowing(userId: ProfileProvider().user!.id);

    setState(() {});
  }
}
