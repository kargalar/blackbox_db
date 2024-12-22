import 'package:blackbox_db/3_Page/ManagerPanel/Widget/select_interval.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class MovieYearStatistics extends StatefulWidget {
  const MovieYearStatistics({super.key});

  @override
  State<MovieYearStatistics> createState() => _MovieYearStatisticsState();
}

class _MovieYearStatisticsState extends State<MovieYearStatistics> {
  List<Map<String, dynamic>>? averageMovieRatingsByYear;

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
          title: "Movie ratings by year",
          onSelected: (interval) async {
            await getData(interval: interval);

            setState(() {});
          },
        ),
        averageMovieRatingsByYear == null
            ? const Center(child: CircularProgressIndicator())
            : averageMovieRatingsByYear!.isEmpty
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No Data',
                      style: TextStyle(fontSize: 15),
                    ),
                  ))
                : SizedBox(
                    width: 500,
                    height: 300,
                    child: SfCircularChart(
                      legend: Legend(isVisible: true),
                      series: <CircularSeries>[
                        DoughnutSeries<Map<String, dynamic>, String>(
                          dataSource: averageMovieRatingsByYear,
                          xValueMapper: (data, _) => data["year"] ?? "",
                          yValueMapper: (data, _) => double.tryParse("${data["average_rating"]}") ?? 0,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }

  Future getData({String? interval}) async {
    averageMovieRatingsByYear = await ServerManager().getAverageMovieRatingsByYear(
      page: 1,
      limit: 10,
      interval: interval ?? "1 weeks",
    );

    setState(() {});
  }
}
