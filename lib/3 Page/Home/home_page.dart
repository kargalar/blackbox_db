import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_movie_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  List<ShowcaseContentModel> contentList = [];

  @override
  void initState() {
    super.initState();

    getContent();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                const Text("activity MOVIE"),
                // TODO istekler contentlistte değil ilgili sayfada atıalcak.
                ContentList(
                  contentList: contentList,
                  showcaseType: ShowcaseTypeEnum.EXPLORE,
                ),
                const Text("activity game"),
                // const ContentList(
                //   contentType: ContentTypeEnum.GAME,
                //   showcaseType: ShowcaseTypeEnum.EXPLORE,
                // ),
                // const Text("trend BOOK"),
                // const ContentList(
                //   contentType: ContentTypeEnum.BOOK,
                //   showcaseType: ShowcaseTypeEnum.TREND,
                // ),
                // const Text("continue GAME"),
                // const ContentList(
                //   contentType: ContentTypeEnum.GAME,
                //   showcaseType: ShowcaseTypeEnum.CONTIUNE,
                // ),
                // const Text("flat GAME"),
                // const ContentList(
                //   contentType: ContentTypeEnum.GAME,
                //   showcaseType: ShowcaseTypeEnum.FLAT,
                // ),
                // const Text("explore all"),
                // const ContentList(
                //   showcaseType: ShowcaseTypeEnum.EXPLORE,
                // ),
                // Divider(color: AppColors.text),
                // const TestItems(),
                // SizedBox(height: 100),
              ],
            ),
          );
  }

  void getContent() async {
    try {
      // TODO: widget.showcaseType a göre farklı endpointlere istek atacak
      // TODO: mesela trend ise sadece 5 tane getirecek. actviity ise contentlogmodel için de veri getirecek...
      // TODO: contentType null ise farklı istek atacak
      if (!isLoading) {
        isLoading = true;
        setState(() {});
      }

      contentList = await ServerManager().getUserContents(
        contentType: ContentTypeEnum.MOVIE,
        userId: userID,
      );

      isLoading = false;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
