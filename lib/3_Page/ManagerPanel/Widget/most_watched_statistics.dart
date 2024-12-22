import 'package:blackbox_db/6_Provider/manager_panel_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MostWatchedStatistics extends StatelessWidget {
  const MostWatchedStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final managerPanelProvider = Provider.of<ManagerPanelProvider>(context);

    return Column(
      children: [
        const Text(
          "Most watched movies",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: 800,
          height: 350,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
            primaryYAxis: NumericAxis(
              interval: 1,
              decimalPlaces: 0,
              isVisible: false,
            ),
            series: <CartesianSeries>[
              BarSeries<Map<String, dynamic>, String>(
                dataSource: managerPanelProvider.mostWatchedMovies,
                xValueMapper: (data, _) => data["title"] ?? "",
                yValueMapper: (data, _) => double.tryParse("${data["watch_count"]}") ?? 0,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
