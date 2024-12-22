import 'package:blackbox_db/3_Page/ManagerPanel/Widget/select_interval.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class ActorStatisticss extends StatefulWidget {
  const ActorStatisticss({super.key});

  @override
  State<ActorStatisticss> createState() => _ActorStatisticssState();
}

class _ActorStatisticssState extends State<ActorStatisticss> {
  List<Map<String, dynamic>>? averageMovieRatingsByGenre;

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
          title: "Movie ratings by genre",
          onSelected: (interval) async {
            await getData(interval: interval);

            setState(() {});
          },
        ),
        averageMovieRatingsByGenre == null
            ? const Center(child: CircularProgressIndicator())
            : averageMovieRatingsByGenre!.isEmpty
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
                          dataSource: averageMovieRatingsByGenre,
                          xValueMapper: (log, _) => log["genre"],
                          yValueMapper: (log, _) => log["average_rating"] ?? 0,
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
    averageMovieRatingsByGenre = await ServerManager().getAverageMovieRatingsByGenre(
      page: 1,
      limit: 10,
      interval: interval ?? "1 weeks",
    );

    setState(() {});
  }
}
