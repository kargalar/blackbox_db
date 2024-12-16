import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/3%20Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/7%20Enum/content_type_enum.dart';
import 'package:blackbox_db/7%20Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8%20Model/showcase_content_model.dart';
import 'package:flutter/material.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  bool isLoading = false;

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
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Devam Edilenler", style: TextStyle(fontSize: 20)),
                  ContentList(
                    contentList: contentList,
                    showcaseType: ShowcaseTypeEnum.TREND,
                  ),
                  // TODO: önce istek at
                  // Text("Son Aktiviteler", style: TextStyle(fontSize: 20)),
                  // ContentList(
                  //   contentList: contentList,
                  //   showcaseType: ShowcaseTypeEnum.FLAT,
                  // ),
                ],
              ),
              SizedBox(width: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Öne Çıkarılanlar", style: TextStyle(fontSize: 20)),
                  ContentList(
                    contentList: contentList,
                    showcaseType: ShowcaseTypeEnum.FLAT,
                  ),
                ],
              ),
            ],
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
      final response = await ServerManager().getUserContents(
        contentType: ContentTypeEnum.MOVIE,
        userId: user.id,
      );

      contentList = response['contentList'];

      // sadece ilk 5 i al
      contentList = contentList.length > 5 ? contentList.sublist(0, 5) : contentList;

      isLoading = false;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
