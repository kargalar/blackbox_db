import 'package:blackbox_db/3_Page/ManagerPanel/Widget/select_interval.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class MovieGenreStatistics extends StatefulWidget {
  const MovieGenreStatistics({super.key});

  @override
  State<MovieGenreStatistics> createState() => _MovieGenreStatisticsState();
}

class _MovieGenreStatisticsState extends State<MovieGenreStatistics> {
  List<Map<String, dynamic>>? topMovieGenres;

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
        topMovieGenres == null
            ? const Center(child: CircularProgressIndicator())
            : topMovieGenres!.isEmpty
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No Data',
                      style: TextStyle(fontSize: 15),
                    ),
                  ))
                : SizedBox(
                    width: 650,
                    height: 300,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                        isVisible: false,
                      ),
                      series: <CartesianSeries>[
                        ColumnSeries<Map<String, dynamic>, String>(
                          dataSource: topMovieGenres,
                          xValueMapper: (log, _) {
                            return log["genre"];
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
    topMovieGenres = await MigrationService().getTopMovieGenres(
      page: 1,
      limit: 20,
      interval: interval ?? "1 weeks",
    );

    setState(() {});
  }
}
