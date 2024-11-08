import 'package:blackbox_db/3%20Page/Content/Widget/content_cover.dart';
import 'package:blackbox_db/3%20Page/Content/Widget/content_informaton.dart';
import 'package:blackbox_db/3%20Page/Content/Widget/content_user_action.dart';
import 'package:blackbox_db/6%20Provider/content_page_provider.dart';
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
  @override
  void initState() {
    super.initState();
    // TODO: istek atıalcak loading olacak şimdilik el ile  context.read<PageProvider>().contentID;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContentPageProvider(),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ContentCover(),
          ContentInformation(),
          ContentUserAction(),
        ],
      ),
    );
  }
}
