import 'package:blackbox_db/6%20Provider/appbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarSearch extends StatefulWidget {
  const AppbarSearch({
    super.key,
  });

  @override
  State<AppbarSearch> createState() => _AppbarSearchState();
}

class _AppbarSearchState extends State<AppbarSearch> {
  @override
  Widget build(BuildContext context) {
    late final appbarProvider = context.read<AppbarProvider>();

    return SizedBox(
      width: 240,
      child: Row(
        children: [
          DropdownButton(
            items: const [
              DropdownMenuItem(value: 0, child: Text('All')),
              DropdownMenuItem(value: 1, child: Text('Movies')),
              DropdownMenuItem(value: 2, child: Text('Games')),
              DropdownMenuItem(value: 3, child: Text('Books')),
            ],
            onChanged: (value) {
              appbarProvider.updatePage(1);
            },
          ),
          SizedBox(
            width: 240,
            child: SearchAnchor(builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
                trailing: const <Widget>[
                  // select filter in list
                  // all, movies, games, books
                ],
              );
            }, suggestionsBuilder: (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            }),
          ),
        ],
      ),
    );
  }
}
