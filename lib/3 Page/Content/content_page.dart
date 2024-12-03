import 'package:blackbox_db/3%20Page/Content/Widget/content_cover.dart';
import 'package:blackbox_db/3%20Page/Content/Widget/content_informaton.dart';
import 'package:blackbox_db/3%20Page/Content/Widget/content_user_action.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/6%20Provider/movie_page_provider.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({
    super.key,
  });

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  bool isLoading = true;

  late final provider = context.read<MoviePageProvider>();

  @override
  void initState() {
    super.initState();

    getContentDetail();
  }

  @override
  void dispose() {
    provider.movieModel = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : provider.movieModel == null
            ? const Center(child: Text("Content not found"))
            : const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContentCover(),
                  ContentInformation(),
                  ContentUserAction(),
                ],
              );
  }

  void getContentDetail() async {
    try {
      provider.movieModel = await ServerManager().getMovieDetail(movieId: context.read<PageProvider>().contentID);
    } catch (e) {
      provider.movieModel = null;
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }
}
