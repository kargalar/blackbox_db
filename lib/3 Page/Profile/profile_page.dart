import 'package:blackbox_db/6%20Provider/appbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final appbarProvider = context.watch<AppbarProvider>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Profile :: ${appbarProvider.currentUserID}"),
    );
  }
}
