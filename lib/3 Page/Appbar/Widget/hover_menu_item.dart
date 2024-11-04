import 'package:flutter/material.dart';

class HoverMenuFilterItem extends StatelessWidget {
  const HoverMenuFilterItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("sadece Movies");
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text("Filter Movies"),
          ],
        ),
      ),
    );
  }
}
