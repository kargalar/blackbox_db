import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_explore_button.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_logo.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_profile.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/appbar_search.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:flutter/material.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 170,
      leading: const AppbarLogo(),
      title: const AppbarSearch(),
      actions: const [
        // test button
        TestButton(),
        AppbarExploreButtons(),
        SizedBox(width: 10),
        AppbarProfile(),
        SizedBox(width: 10),
      ],
    );
  }
}

// test button get data
class TestButton extends StatefulWidget {
  const TestButton({super.key});

  @override
  State<TestButton> createState() => _TestButtonState();
}

class _TestButtonState extends State<TestButton> {
  bool? isLoading;

  ServerManager serverManager = ServerManager();

  late List genres;

  @override
  Widget build(BuildContext context) {
    return isLoading == null
        ? ElevatedButton(
            onPressed: () async {
              try {
                // get genres
                var asdasd = await serverManager.getGenres();
                setState(() {
                  genres = asdasd;
                  isLoading = false;
                });
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            child: const Text('Get Genres'),
          )
        : isLoading!
            ? const CircularProgressIndicator()
            : Text('Genres: $genres');
  }
}
