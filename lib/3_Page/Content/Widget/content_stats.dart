import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/8_Model/content_model.dart';
import 'package:flutter/material.dart';

class ContentStats extends StatelessWidget {
  final ContentModel content;
  const ContentStats({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.panelBackground,
              borderRadius: AppColors.borderRadiusAll,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final canWrap = constraints.maxWidth < 420;
                    final children = <Widget>[
                      _StatChip(icon: Icons.remove_red_eye, label: 'İzlenme', value: content.consumeCount ?? 0),
                      _StatChip(icon: Icons.favorite, label: 'Favori', value: content.favoriCount ?? 0, iconColor: AppColors.dirtyRed),
                      _StatChip(icon: Icons.playlist_add, label: 'Liste', value: content.listCount ?? 0, iconColor: AppColors.main),
                      _StatChip(icon: Icons.rate_review, label: 'Yorum', value: content.reviewCount ?? 0),
                    ];
                    if (canWrap) {
                      return Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        alignment: WrapAlignment.spaceBetween,
                        children: children,
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: children,
                    );
                  },
                ),
                const SizedBox(height: 16),
                _RatingBarsChart(distribution: content.ratingDistribution, average: content.rating),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color? iconColor;

  const _StatChip({required this.icon, required this.label, required this.value, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? AppColors.text.withValues(alpha: 0.9)),
        const SizedBox(height: 4),
        Text('$value', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text)),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.text.withValues(alpha: 0.7))),
      ],
    );
  }
}

class _AvgRatingChip extends StatelessWidget {
  final double? average;
  const _AvgRatingChip({required this.average});

  @override
  Widget build(BuildContext context) {
    final avg = (average ?? 0).toStringAsFixed(1);
    return Column(
      children: [
        const Icon(Icons.star, color: Colors.amber),
        const SizedBox(height: 4),
        Text(avg, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text)),
        Text('Ortalama', style: TextStyle(fontSize: 12, color: AppColors.text.withValues(alpha: 0.7))),
      ],
    );
  }
}

class _RatingBarsChart extends StatelessWidget {
  final List<int>? distribution; // index 0 => 1 star, ... index 4 => 5 stars
  final double? average;
  const _RatingBarsChart({required this.distribution, required this.average});

  @override
  Widget build(BuildContext context) {
    final data = (distribution == null || distribution!.isEmpty) ? List<int>.filled(5, 0) : (distribution!.length == 5 ? distribution! : List<int>.generate(5, (i) => i < distribution!.length ? distribution![i] : 0));

    final maxVal = (data.isEmpty ? 0 : data.reduce((a, b) => a > b ? a : b));
    final avg = (average ?? 0).toStringAsFixed(1);

    const double chartHeight = 120.0;
    const double gap = 4.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth;
              const double minBarW = 4.0;
              const double maxBarW = 22.0;
              const double paddingH = 12.0; // 6 + 6
              final double usableW = (maxW - paddingH).clamp(0.0, double.infinity);
              final double totalGap = gap * 4.0;
              final double computedBarW = ((usableW - totalGap) / 5.0).clamp(minBarW, maxBarW);

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                decoration: BoxDecoration(
                  color: AppColors.panelBackground2.withValues(alpha: 0.3),
                  borderRadius: AppColors.borderRadiusAll,
                ),
                child: SizedBox(
                  height: chartHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(5, (i) {
                      final idx = i; // left to right: 1..5
                      final count = data[idx];
                      final ratio = maxVal == 0 ? 0.0 : (count / maxVal).clamp(0.0, 1.0);
                      final barH = (chartHeight * ratio);
                      return Padding(
                        padding: EdgeInsets.only(right: i == 4 ? 0 : gap),
                        child: Container(
                          width: computedBarW,
                          height: barH,
                          decoration: BoxDecoration(
                            borderRadius: AppColors.borderRadiusAll,
                            border: Border.all(color: AppColors.panelBackground2, width: 1),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.lightMain.withValues(alpha: 0.85),
                                AppColors.main.withValues(alpha: 0.95),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ortalama', style: TextStyle(fontSize: 12, color: AppColors.text.withValues(alpha: 0.7))),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 20, color: Colors.amber),
                const SizedBox(width: 6),
                Text(avg, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
