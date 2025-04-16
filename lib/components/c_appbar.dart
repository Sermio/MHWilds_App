import 'package:flutter/material.dart';

class Cappbar extends StatelessWidget implements PreferredSizeWidget {
  const Cappbar({super.key, this.title = ""});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 10,
      // backgroundColor: Colors.transparent,
      flexibleSpace: Stack(
        children: [
          Container(
              // color: const Color(0xFFC3A35D),
              ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 5.0),
          //   child: Center(
          //     child: Image.asset(
          //       height: 150,
          //       width: 150,
          //       'assets/imgs/logo/logo512transparent.png',
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
