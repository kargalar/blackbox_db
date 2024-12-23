import 'package:blackbox_db/2_General/Widget/profile_picture.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: following.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            ProfilePicture(
              imageUrl: following[index]['picture_path'],
              userID: following[index]['id'],
            ),
            Text(following[index]['username']),
          ],
        );
      },
    );
    // Row(
    //   children: [
    //     // followers
    //     Column(
    //       children: [
    //         Text('Followers'),
    //         ListView.builder(
    //           shrinkWrap: true,
    //           itemCount: followers.length,
    //           itemBuilder: (context, index) {
    //             return ListTile(
    //               title: Text(followers[index]['id']),
    //               subtitle: Text(followers[index]['username']),
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //     // following
    //     Column(
    //       children: [
    //         Text('Following'),
    //         ListView.builder(
    //           shrinkWrap: true,
    //           itemCount: following.length,
    //           itemBuilder: (context, index) {
    //             return ListTile(
    //               title: Text(following[index]['id']),
    //               subtitle: Text(following[index]['username']),
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  void getData() async {
    // followers = await ServerManager().getFollowers(userId: ProfileProvider().user!.id);
    following = await ServerManager().getFollowing(userId: ProfileProvider().user!.id);

    setState(() {});
  }
}
