import 'package:blackbox_db/3_Page/Content/Widget/content_cover.dart';
import 'package:blackbox_db/3_Page/Content/Widget/content_informaton.dart';
import 'package:blackbox_db/3_Page/Content/Widget/Review/content_reviews.dart';
import 'package:blackbox_db/3_Page/Content/Widget/content_user_action.dart';
import 'package:blackbox_db/5_Service/external_api_service.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/6_Provider/content_page_provider.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
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
  void dispose() {
    provider.contentModel = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : provider.contentModel == null
            ? const Center(child: Text("Content not found"))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ContentCover(),
                        ContentInformation(),
                        ContentUserAction(),
                      ],
                    ),
                    SizedBox(height: 40),
                    ContentReviews(contentId: provider.contentModel!.id!),
                    SizedBox(height: 100),
                  ],
                ),
              );
  }

  void getContentDetail() async {
    try {
      final contentId = context.read<GeneralProvider>().contentID;
      final contentType = context.read<GeneralProvider>().contentPageContentTpye;

      // ContentTypeEnum'dan contentTypeId'ye çevir
      int contentTypeId;
      if (contentType.toString().contains('MOVIE')) {
        contentTypeId = 1; // Movie
      } else if (contentType.toString().contains('GAME')) {
        contentTypeId = 2; // Game
      } else {
        contentTypeId = 1; // Default to movie
      }

      String? currentUserId;
      try {
        final currentUser = await MigrationService().getCurrentUserProfile();
        currentUserId = currentUser?.id;
      } catch (e) {
        debugPrint('Current user ID alınamadı: $e');
      }

      // ExternalApiService ile veri çek (Smart caching: Supabase first, API fallback)
      provider.contentModel = await ExternalApiService().getContentDetail(
        contentId: contentId,
        contentTypeId: contentTypeId,
        userId: currentUserId, // User logs için gerekli
      );
    } catch (e) {
      provider.contentModel = null;
      debugPrint('Content detail error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }
}
