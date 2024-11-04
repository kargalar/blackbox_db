import 'package:blackbox_db/6%20Provider/appbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final appbarProvider = context.watch<AppbarProvider>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("EXPLORE    :::  ${appbarProvider.exploreContentType}"),
    );
  }
}
