import 'package:blackbox_db/3_Page/ManagerPanel/Widget/select_interval.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class MovieGenreStatistics extends StatefulWidget {
  const MovieGenreStatistics({super.key});

  @override
  State<MovieGenreStatistics> createState() => _MovieGenreStatisticsState();
}

class _MovieGenreStatisticsState extends State<MovieGenreStatistics> {
  List<Map<String, dynamic>> topMovieGenres = [];

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
          title: "Most consumed movie genres",
          onSelected: (interval) async {
            await getData(interval: interval);

            setState(() {});
          },
        ),
        SizedBox(
          width: 500,
          height: 300,
          child: SfCircularChart(
            legend: Legend(isVisible: true),
            series: <CircularSeries>[
              DoughnutSeries<Map<String, dynamic>, String>(
                dataSource: topMovieGenres,
                xValueMapper: (data, _) => data["genre"] ?? "",
                yValueMapper: (data, _) => double.tryParse("${data["log_count"]}") ?? 0,
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future getData({String? interval}) async {
    topMovieGenres = await ServerManager().getTopMovieGenres(
      page: 1,
      limit: 10,
      interval: interval ?? "1 weeks",
    );

    setState(() {});
  }
}
