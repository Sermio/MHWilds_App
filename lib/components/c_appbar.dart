import 'package:flutter/material.dart';

class Cappbar extends StatelessWidget implements PreferredSizeWidget {
  const Cappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 35,
        ),
        elevation: 10,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.green,
                Colors.transparent,
              ],
            ),
          ),
        ),
        // backgroundColor: Colors.transparent,
        // flexibleSpace: Image.asset(
        //   'assets/imgs/banner/banner.png',
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
