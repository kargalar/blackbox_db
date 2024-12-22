import 'package:blackbox_db/3_Page/ManagerPanel/Widget/select_interval.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeekdayWatchCountStatistics extends StatefulWidget {
  const WeekdayWatchCountStatistics({super.key});

  @override
  State<WeekdayWatchCountStatistics> createState() => _WeekdayWatchCountStatisticsState();
}

class _WeekdayWatchCountStatisticsState extends State<WeekdayWatchCountStatistics> {
  List<Map<String, dynamic>> weeklyContentLogs = [];

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectInterval(
          title: "Movie views",
          onSelected: (interval) async {
            await getData(interval: interval);

            setState(() {});
          },
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
                dataLabelSettings: DataLabelSettings(isVisible: true),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future getData({String? interval}) async {
    weeklyContentLogs = await ServerManager().getWeeklyContentLogs(
      page: 1,
      limit: 10,
      interval: interval ?? "1 weeks",
    );

    weeklyContentLogs = List.generate(7, (index) {
      final dayLog = weeklyContentLogs.firstWhere(
        (log) => log["day_of_week"] == index,
        orElse: () => {"day_of_week": index, "log_count": "0"},
      );
      return dayLog;
    });
    setState(() {});
  }
}
