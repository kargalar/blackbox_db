import 'package:blackbox_db/3_Page/ManagerPanel/Widget/select_interval.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class ActorStatistics extends StatefulWidget {
  const ActorStatistics({super.key});

  @override
  State<ActorStatistics> createState() => _ActorStatisticsState();
}

class _ActorStatisticsState extends State<ActorStatistics> {
  List<Map<String, dynamic>>? topActorsByMovieCount;

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
          title: "Top actors",
          onSelected: (interval) async {
            await getData(interval: interval);

            setState(() {});
          },
        ),
        topActorsByMovieCount == null
            ? const Center(child: CircularProgressIndicator())
            : topActorsByMovieCount!.isEmpty
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
                          dataSource: topActorsByMovieCount,
                          xValueMapper: (data, _) => data["actor_name"] ?? "",
                          yValueMapper: (data, _) => double.tryParse("${data["movie_count"]}") ?? 0,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }

  Future getData({String? interval}) async {
    topActorsByMovieCount = await ServerManager().getTopActorsByMovieCount(
      page: 1,
      limit: 10,
      interval: interval ?? "1 weeks",
    );

    setState(() {});
  }
}
