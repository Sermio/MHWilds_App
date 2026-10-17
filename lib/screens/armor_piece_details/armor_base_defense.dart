import 'package:flutter/material.dart';

class ArmorBaseDefense extends StatelessWidget {
  final int baseDefense;

  const ArmorBaseDefense({super.key, required this.baseDefense});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(baseDefense.toString()),
        const SizedBox(width: 5),
        SizedBox(
          height: 20,
          child: Image.asset('assets/imgs/armor/armor.webp',
              excludeFromSemantics: true),
        ),
      ],
    );
  }
}
