import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final appbarProvider = context.watch<PageProvider>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(appbarProvider.searchText),
    );
  }
}
