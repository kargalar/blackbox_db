import 'package:blackbox_db/3%20Page/Content/Widget/content_cover.dart';
import 'package:blackbox_db/3%20Page/Content/Widget/content_informaton.dart';
import 'package:blackbox_db/3%20Page/Content/Widget/content_user_action.dart';
import 'package:blackbox_db/5%20Service/tmdb_service.dart';
import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
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

  late final provider = context.read<ContentPageProvider>();

  @override
  void initState() {
    super.initState();

    getContentDetail();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : provider.contentModel == null
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
      provider.contentModel = await TMDBService().getDetail(context.read<PageProvider>().contentID);
    } catch (e) {
      provider.contentModel = null;
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }
}
