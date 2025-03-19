import 'package:flutter/material.dart';

class Cappbar extends StatelessWidget implements PreferredSizeWidget {
  const Cappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 35,
      ),
      elevation: 10,
      flexibleSpace: Image.asset(
        'assets/imgs/banner/banner.png',
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
