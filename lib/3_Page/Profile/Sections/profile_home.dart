import 'package:blackbox_db/3_Page/Explore/Widget/content_list.dart';
import 'package:blackbox_db/3_Page/Profile/Widget/profile_statistics.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:blackbox_db/7_Enum/showcase_type_enum.dart';
import 'package:blackbox_db/8_Model/showcase_content_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  bool isLoading = false;

  List<ShowcaseContentModel> lastMovieActivitiyContentList = [];
  List<ShowcaseContentModel> lastGameActivitiyContentList = [];

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
                  ProfileStatistics(),
                  // SizedBox(height: 40),
                  // TODO:
                  // Text("In Progress", style: TextStyle(fontSize: 20)),
                  // ContentList(
                  //   contentList: lastMovieActivitiyContentList,
                  //   showcaseType: ShowcaseTypeEnum.TREND,
                  // ),
                  // TODO: önce istek at
                  // Text("Highlights", style: TextStyle(fontSize: 20)),
                  // ContentList(
                  //   contentList: lastMovieActivitiyContentList,
                  //   showcaseType: ShowcaseTypeEnum.FLAT,
                  // ),
                ],
              ),
              SizedBox(width: 60),
              // TODO:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Last Game Activities", style: TextStyle(fontSize: 20)),
                  ContentList(
                    contentList: lastGameActivitiyContentList,
                    showcaseType: ShowcaseTypeEnum.ACTIVITY,
                  ),
                  Text("Last Movie Activities", style: TextStyle(fontSize: 20)),
                  ContentList(
                    contentList: lastMovieActivitiyContentList,
                    showcaseType: ShowcaseTypeEnum.ACTIVITY,
                  ),
                ],
              ),
            ],
          );
  }

  void getContent() async {
    try {
      if (!isLoading) {
        isLoading = true;
        setState(() {});
      }

      // TODO: devam edilenlere ve önce çıkarıalnlara istek atılacak onlar getirliecek
      final response = await MigrationService().getUserActivities(
        profileUserID: context.read<ProfileProvider>().user!.id,
        contentType: ContentTypeEnum.MOVIE,
      );

      lastMovieActivitiyContentList = response['contentList'];
      // sadece ilk 5 i al. burası normalde olmayacak. çünkü zaten buna istek atmayacağız
      lastMovieActivitiyContentList = lastMovieActivitiyContentList.length > 5 ? lastMovieActivitiyContentList.sublist(0, 5) : lastMovieActivitiyContentList;

      final response2 = await MigrationService().getUserActivities(
        // ignore: use_build_context_synchronously
        profileUserID: context.read<ProfileProvider>().user!.id,
        contentType: ContentTypeEnum.GAME,
      );

      lastGameActivitiyContentList = response2['contentList'];
      // sadece ilk 5 i al. burası normalde olmayacak. çünkü zaten buna istek atmayacağız
      lastGameActivitiyContentList = lastGameActivitiyContentList.length > 5 ? lastGameActivitiyContentList.sublist(0, 5) : lastGameActivitiyContentList;

      isLoading = false;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
