import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blackbox_db/6_Provider/manager_panel_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeekdayWatchCountStatistics extends StatelessWidget {
  const WeekdayWatchCountStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final managerPanelProvider = Provider.of<ManagerPanelProvider>(context);

    // Verileri işleyerek her gün için bir değer olduğundan emin olun
    final List<Map<String, dynamic>> weeklyContentLogs = List.generate(7, (index) {
      final dayLog = managerPanelProvider.weeklyContentLogs.firstWhere(
        (log) => log["day_of_week"] == index,
        orElse: () => {"day_of_week": index, "log_count": "0"},
      );
      return dayLog;
    });

    return Column(
      children: [
        const Text(
          "Movie views by day",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: 500,
          height: 300,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              isVisible: false,
            ),
            series: <CartesianSeries>[
              ColumnSeries<Map<String, dynamic>, String>(
                dataSource: weeklyContentLogs,
                xValueMapper: (log, _) {
                  const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                  return weekdays[log["day_of_week"]];
                },
                yValueMapper: (log, _) => int.tryParse(log["log_count"]) ?? 0,
                color: Colors.blue,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                enableTooltip: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
