import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget? title;
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
  final Color? shadowColor;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    this.title,
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
    this.shadowColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Material(
          elevation: elevation,
          shadowColor: shadowColor, // <-- Aquí se usa
          borderRadius: borderRadius,
          color: backgroundColor,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
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
                      title ?? const Text(""),
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
