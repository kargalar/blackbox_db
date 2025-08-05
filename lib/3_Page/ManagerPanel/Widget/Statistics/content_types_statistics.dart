import 'package:blackbox_db/3_Page/ManagerPanel/Widget/select_interval.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class ContentTypeStatistics extends StatefulWidget {
  const ContentTypeStatistics({super.key});

  @override
  State<ContentTypeStatistics> createState() => _ContentTypeStatisticsState();
}

class _ContentTypeStatisticsState extends State<ContentTypeStatistics> {
  List<Map<String, dynamic>>? topContentTypes;

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
          title: "Most consumed content types",
          onSelected: (interval) async {
            await getData(interval: interval);

            setState(() {});
          },
        ),
        topContentTypes == null
            ? const Center(child: CircularProgressIndicator())
            : topContentTypes!.isEmpty
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No Data',
                      style: TextStyle(fontSize: 15),
                    ),
                  ))
                : SizedBox(
                    width: 400,
                    height: 300,
                    child: SfCircularChart(
                      legend: Legend(isVisible: true),
                      series: <CircularSeries>[
                        DoughnutSeries<Map<String, dynamic>, String>(
                          dataSource: topContentTypes,
                          xValueMapper: (data, _) => data["content_type"] ?? "",
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
    topContentTypes = await MigrationService().getTopContentTypes(
      page: 1,
      limit: 10,
      interval: interval ?? "1 weeks",
    );

    setState(() {});
  }
}
