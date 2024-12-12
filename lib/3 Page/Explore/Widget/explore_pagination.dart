import 'dart:math';

import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/explore_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorePagination extends StatelessWidget {
  const ExplorePagination({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void getContents() {
      Provider.of<ExploreProvider>(context, listen: false).getContent(context);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // First page button (show only if page 1 won't be in the generated range)
        if (ExploreProvider().currentPageIndex > 2)
          TextButton(
            onPressed: () {
              ExploreProvider().currentPageIndex = 1;
              getContents();
            },
            child: const Text('1'),
          ),

        // Show dots if there's gap between first and current-1
        if (ExploreProvider().currentPageIndex > 3) const Text('...', style: TextStyle(fontWeight: FontWeight.bold)),

        // Generate page buttons (current + up to 4 after if current is 1, otherwise 1 before + current + 3 after)
        ...List.generate(
          min(
            ExploreProvider().currentPageIndex == 1 ? 5 : 5, // Keep showing 5 total buttons
            ExploreProvider().totalPageIndex,
          ),
          (index) {
            // If current page is 1, start from 1, otherwise start from current-1
            final pageNum = ExploreProvider().currentPageIndex == 1 ? index + 1 : max(1, ExploreProvider().currentPageIndex - 1 + index);

            if (pageNum > ExploreProvider().totalPageIndex) return const SizedBox.shrink();

            return TextButton(
              onPressed: () {
                ExploreProvider().currentPageIndex = pageNum;
                getContents();
              },
              style: TextButton.styleFrom(
                backgroundColor: pageNum == ExploreProvider().currentPageIndex ? AppColors.blue : null,
              ),
              child: Text('$pageNum'),
            );
          },
        ),

        // Last page button (if not already shown)
        if (ExploreProvider().currentPageIndex + 3 < ExploreProvider().totalPageIndex) ...[
          const Text('...', style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () {
              ExploreProvider().currentPageIndex = ExploreProvider().totalPageIndex;
              getContents();
            },
            child: Text('${ExploreProvider().totalPageIndex}'),
          ),
        ]
      ],
    );
  }
}
