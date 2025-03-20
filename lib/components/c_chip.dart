import 'package:flutter/material.dart';
// import 'package:mh_app/data/monster.dart';
// import 'package:mh_app/screens/monster_map_details_screen.dart';

class Cchip<T> extends StatelessWidget {
  // final T item;
  final T chipItem;
  final String itemName;
  final Color Function(String) getItemColor;
  final Widget? optionalWidget;

  const Cchip({
    super.key,
    // required this.item,
    required this.chipItem,
    required this.itemName,
    required this.getItemColor,
    this.optionalWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => MonsterMapDetails(
        //             map: chipItem as MonsterLocation,
        //           )),
        // );
      },
      child: Chip(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        elevation: 5,
        shadowColor: Colors.black,
        backgroundColor: getItemColor(itemName),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              itemName.isNotEmpty ? itemName : "Unknown",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            if (optionalWidget != null) ...[
              const SizedBox(width: 6),
              optionalWidget!,
            ],
          ],
        ),
      ),
    );
  }
}
