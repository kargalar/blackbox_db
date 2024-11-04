import 'package:flutter/material.dart';

class HoverMenuItem extends StatelessWidget {
  const HoverMenuItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("profile");
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text("filter movie"),
          ],
        ),
      ),
    );
  }
}
