import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/decoration_details.dart';
import 'package:mhwilds_app/screens/monster_details.dart';

class CustomCard extends StatelessWidget {
  final dynamic cardData;
  final Widget title;
  final Widget? body;
  final Widget? subtitle1;
  final Widget? subtitle2;
  final Widget? leading;
  final Widget? trailing;
  final bool bodyOnTop;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final double elevation;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.cardData,
    required this.title,
    this.body,
    this.subtitle1,
    this.subtitle2,
    this.leading,
    this.trailing,
    this.bodyOnTop = true,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 8),
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.elevation = 3.0,
    this.onTap,
  });

  void _defaultNavigation(BuildContext context) {
    if (cardData is Monster) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MonsterDetails(monster: cardData),
        ),
      );
    } else if (cardData is DecorationItem) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DecorationDetails(decoration: cardData),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _defaultNavigation(context),
      child: Padding(
        padding: padding,
        child: Material(
          elevation: elevation,
          borderRadius: borderRadius,
          color: backgroundColor,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: backgroundColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      bodyOnTop && body != null ? body! : const SizedBox(),
                      if (bodyOnTop && body != null) const SizedBox(height: 8),
                      const SizedBox(height: 6),
                      if (subtitle1 != null) subtitle1!,
                      if (subtitle2 != null) ...[
                        const SizedBox(height: 4),
                        subtitle2!,
                      ],
                      if (!bodyOnTop && body != null) ...[
                        const SizedBox(height: 8),
                        body!,
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
