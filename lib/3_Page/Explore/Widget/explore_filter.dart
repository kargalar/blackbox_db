import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/3_Page/Explore/Widget/select_filter.dart';
import 'package:blackbox_db/6_Provider/explore_provider.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/7_Enum/content_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ExploreFilter extends StatefulWidget {
  const ExploreFilter({
    super.key,
  });

  @override
  State<ExploreFilter> createState() => _ExploreFilterState();
}

class _ExploreFilterState extends State<ExploreFilter> {
  final TextEditingController _yearFromController = TextEditingController();
  final TextEditingController _yearToController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _yearFromController.text = ExploreProvider().yearFromFilter ?? '';
    _yearToController.text = ExploreProvider().yearToFilter ?? '';
  }

  void _applyYearRange() {
    final from = _yearFromController.text.trim();
    final to = _yearToController.text.trim();
    String? validFrom;
    String? validTo;
    if (from.isNotEmpty && RegExp(r'^\d{4}$').hasMatch(from)) validFrom = from;
    if (to.isNotEmpty && RegExp(r'^\d{4}$').hasMatch(to)) validTo = to;
    ExploreProvider().yearFromFilter = validFrom;
    ExploreProvider().yearToFilter = validTo;
    ExploreProvider().currentPageIndex = 1;
    ExploreProvider().getContent(context: context);
    setState(() {});
  }

  @override
  void dispose() {
    _yearFromController.dispose();
    _yearToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 600,
      decoration: BoxDecoration(
        borderRadius: AppColors.borderRadiusAll,
        color: AppColors.panelBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: RatingBar.builder(
                initialRating: ExploreProvider().minRatingFilter != null ? (ExploreProvider().minRatingFilter! / 2).clamp(0, 5) : 0,
                minRating: 0.5,
                direction: Axis.horizontal,
                glow: false,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 35,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: AppColors.main,
                ),
                onRatingUpdate: (rating) {
                  // UI yıldızı 0-5 gösterir, TMDB 0-10 ister
                  ExploreProvider().minRatingFilter = (rating * 2).clamp(0, 10);
                  ExploreProvider().currentPageIndex = 1; // filtre değişince başa dön
                  ExploreProvider().getContent(context: context);
                },
              ),
            ),
            const SizedBox(height: 15),
            // Yıl aralığı
            Text(
              'Year Range',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _yearFromController,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: '',
                      isDense: true,
                      hintText: 'From',
                      filled: true,
                      fillColor: AppColors.panelBackground2,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    onSubmitted: (_) => _applyYearRange(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _yearToController,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: '',
                      isDense: true,
                      hintText: 'To',
                      filled: true,
                      fillColor: AppColors.panelBackground2,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    onSubmitted: (_) => _applyYearRange(),
                  ),
                ),
                IconButton(
                  tooltip: 'Apply',
                  onPressed: _applyYearRange,
                  icon: const Icon(Icons.check, size: 20),
                ),
                if (ExploreProvider().yearFromFilter != null || ExploreProvider().yearToFilter != null)
                  IconButton(
                    tooltip: 'Clear',
                    onPressed: () {
                      _yearFromController.clear();
                      _yearToController.clear();
                      ExploreProvider().yearFromFilter = null;
                      ExploreProvider().yearToFilter = null;
                      ExploreProvider().currentPageIndex = 1;
                      ExploreProvider().getContent(context: context);
                      setState(() {});
                    },
                    icon: const Icon(Icons.close, size: 18),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            if (GeneralProvider().exploreContentType == ContentTypeEnum.MOVIE ? ExploreProvider().allMovieGenres != null : ExploreProvider().allGameGenres != null)
              SelectFilter(
                title: "Genre",
                addItem: (item) {
                  ExploreProvider().genreFilteredList.add(item);
                  ExploreProvider().getContent(context: context);
                },
                removeItem: (item) {
                  ExploreProvider().genreFilteredList.remove(item);
                  ExploreProvider().getContent(context: context);
                },
                allItemList: GeneralProvider().exploreContentType == ContentTypeEnum.MOVIE ? ExploreProvider().allMovieGenres! : ExploreProvider().allGameGenres!,
                filteredItemList: ExploreProvider().genreFilteredList,
              ),
            if (GeneralProvider().exploreContentType == ContentTypeEnum.MOVIE
                ? ExploreProvider().allMovieLanguage != null
                :
                //  ExploreProvider().allGameLanguage != null
                false)
              SelectFilter(
                title: "Language",
                addItem: (item) {
                  ExploreProvider().languageFilter = item;
                  ExploreProvider().getContent(context: context);
                },
                removeItem: (item) {
                  ExploreProvider().languageFilter = null;
                  ExploreProvider().getContent(context: context);
                },
                // allItemList: GeneralProvider().exploreContentType == ContentTypeEnum.MOVIE ? ExploreProvider().allMovieLanguage! : ExploreProvider().allGameLanguage!,
                allItemList: ExploreProvider().allMovieLanguage!,
                selectedItem: ExploreProvider().languageFilter,
              ),
          ],
        ),
      ),
    );
  }
}
