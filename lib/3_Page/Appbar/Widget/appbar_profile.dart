import 'package:blackbox_db/2_General/Widget/profile_picture.dart';
import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/3_Page/Appbar/Widget/profile_hover_menu.dart';
import 'package:flutter/material.dart';

class AppbarProfile extends StatefulWidget {
  const AppbarProfile({
    super.key,
  });

  @override
  State<AppbarProfile> createState() => _AppbarProfileState();
}

class _AppbarProfileState extends State<AppbarProfile> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _hoverCheck(true),
      onExit: (event) => _hoverCheck(false),
      child: ProfilePicture.appBar(
        imageUrl: loginUser!.picturePath,
        userID: loginUser!.id,
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
        top: 49,
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
