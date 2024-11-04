import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/Appbar/Widget/profile_hover_menu.dart';
import 'package:blackbox_db/6%20Provider/appbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarProfile extends StatefulWidget {
  const AppbarProfile({
    super.key,
  });

  @override
  State<AppbarProfile> createState() => _AppbarProfileState();
}

class _AppbarProfileState extends State<AppbarProfile> {
  late final appbarProvider = context.read<AppbarProvider>();

  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _hoverCheck(true),
      onExit: (event) => _hoverCheck(false),
      child: Center(
        child: InkWell(
          borderRadius: AppColors.borderRadiusCircular,
          onTap: () {
            // TODO: burada kullanıcının kendi id si verilecek
            appbarProvider.profile("aq6tj5sxc");
          },
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: ClipRRect(
              borderRadius: AppColors.borderRadiusCircular,
              child: SizedBox(
                width: 45,
                height: 45,
                child: Image.network(
                  fit: BoxFit.cover,
                  "https://images.pexels.com/photos/29191749/pexels-photo-29191749/free-photo-of-traditional-farmer-in-rural-vietnamese-setting.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _hoverCheck(bool hovering) {
    if (hovering) {
      _showMenu();
    } else {
      _removeMenu();
    }
  }

  void _showMenu() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        right: 0,
        top: 55,
        child: MouseRegion(
          onEnter: (event) => _hoverCheck(true),
          onExit: (event) => _hoverCheck(false),
          child: const ProfileHoverMenu(),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
