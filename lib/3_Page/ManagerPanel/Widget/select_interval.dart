import 'package:flutter/material.dart';

class SelectInterval extends StatefulWidget {
  const SelectInterval({
    super.key,
    required this.title,
    required this.onSelected,
  });

  final String title;
  final Function(String) onSelected;

  @override
  State<SelectInterval> createState() => _SelectIntervalState();
}

class _SelectIntervalState extends State<SelectInterval> {
  List<String> intervalListText = ["Daily", "Weekly", "Monthly", "Yearly", "All Time"];
  List<String> intervalList = ["1 day", "1 week", "1 month", "1 year", "999 year"];
  int interval = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 20),
        PopupMenuButton<int>(
          icon: Row(
            children: [
              Text(intervalListText[interval]),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Text(intervalListText[0]),
            ),
            PopupMenuItem(
              value: 1,
              child: Text(intervalListText[1]),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(intervalListText[2]),
            ),
            PopupMenuItem(
              value: 3,
              child: Text(intervalListText[3]),
            ),
            PopupMenuItem(
              value: 4,
              child: Text(intervalListText[4]),
            ),
          ],
          onSelected: (value) async {
            await widget.onSelected(intervalList[value]);
            interval = value;
            setState(() {});
          },
        ),
      ],
    );
  }
}
