import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/3_Page/Content/Widget/Review/review_item.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:blackbox_db/6_Provider/content_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ContentReviews extends StatefulWidget {
  const ContentReviews({
    super.key,
    required this.contentId,
  });

  final int contentId;

  @override
  State<ContentReviews> createState() => _ContentReviewsState();
}

class _ContentReviewsState extends State<ContentReviews> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // get content reviews
    getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : context.watch<ContentPageProvider>().reviewList.isEmpty
            ? const Center(
                child: Text(
                  'No reviews found',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    color: AppColors.panelBackground2,
                    offset: const Offset(0, 35),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false, // Allows customization with custom widget
                        child: StatefulBuilder(builder: (context, setStateMenu) {
                          return SizedBox(
                            width: 100, // Adjust width
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    // add or remove genre
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Most Popular",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Most Popular",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.4.sw,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: ContentPageProvider().reviewList.length,
                      itemBuilder: (context, index) {
                        return ReviewItem(
                          reviewModel: ContentPageProvider().reviewList[index],
                        );
                      },
                    ),
                  ),
                ],
              );
  }

  void getReviews() async {
    ContentPageProvider().reviewList = await ServerManager().getContentReviews(contentId: widget.contentId);

    setState(() {
      isLoading = false;
    });
  }
}
