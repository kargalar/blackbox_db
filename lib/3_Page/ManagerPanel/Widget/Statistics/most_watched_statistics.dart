import 'package:blackbox_db/3_Page/ManagerPanel/Widget/select_interval.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class MostWatchedStatistics extends StatefulWidget {
  const MostWatchedStatistics({super.key});

  @override
  State<MostWatchedStatistics> createState() => _MostWatchedStatisticsState();
}

class _MostWatchedStatisticsState extends State<MostWatchedStatistics> {
  List<Map<String, dynamic>>? mostWatchedMovies;

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
          title: "Most watched movies",
          onSelected: (interval) async {
            await getData(interval: interval);

            setState(() {});
          },
        ),
        mostWatchedMovies == null
            ? const Center(child: CircularProgressIndicator())
            : mostWatchedMovies!.isEmpty
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No Data',
                      style: TextStyle(fontSize: 15),
                    ),
                  ))
                : SizedBox(
                    width: 800,
                    height: 350,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        isVisible: false,
                      ),
                      series: <CartesianSeries>[
                        BarSeries<Map<String, dynamic>, String>(
                          dataSource: mostWatchedMovies,
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

  Future getData({String? interval}) async {
    mostWatchedMovies = await ServerManager().getMostWatchedMovies(
      page: 1,
      limit: 10,
      interval: interval ?? "1 weeks",
    );
    setState(() {});
  }
}
