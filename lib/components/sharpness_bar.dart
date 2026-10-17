import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/utils/game_colors.dart';

class SharpnessBar extends StatelessWidget {
  final Sharpness sharpness;
  final double height;
  final double borderRadius;

  const SharpnessBar({
    super.key,
    required this.sharpness,
    this.height = 20,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final game = GameColors.of(context);
    // Crear lista de segmentos para poder identificar el último
    final List<Widget> segments = [];

    if (sharpness.red > 0) {
      segments.add(_buildSharpnessSegment(
        sharpness.red,
        game.sharpnessRed,
        isFirst: segments.isEmpty,
        isLast: false,
      ));
    }
    if (sharpness.orange > 0) {
      segments.add(_buildSharpnessSegment(
        sharpness.orange,
        game.sharpnessOrange,
        isFirst: segments.isEmpty,
        isLast: false,
      ));
    }
    if (sharpness.yellow > 0) {
      segments.add(_buildSharpnessSegment(
        sharpness.yellow,
        game.sharpnessYellow,
        isFirst: segments.isEmpty,
        isLast: false,
      ));
    }
    if (sharpness.green > 0) {
      segments.add(_buildSharpnessSegment(
        sharpness.green,
        game.sharpnessGreen,
        isFirst: segments.isEmpty,
        isLast: false,
      ));
    }
    if (sharpness.blue > 0) {
      segments.add(_buildSharpnessSegment(
        sharpness.blue,
        game.sharpnessBlue,
        isFirst: segments.isEmpty,
        isLast: false,
      ));
    }
    if (sharpness.white > 0) {
      segments.add(_buildSharpnessSegment(
        sharpness.white,
        game.sharpnessWhite,
        isFirst: segments.isEmpty,
        isLast: false,
      ));
    }
    if (sharpness.purple > 0) {
      segments.add(_buildSharpnessSegment(
        sharpness.purple,
        game.sharpnessPurple,
        isFirst: segments.isEmpty,
        isLast: false,
      ));
    }

    // Marcar el último segmento como último
    if (segments.isNotEmpty) {
      segments.last = _buildSharpnessSegment(
        _getLastSegmentValue(),
        _getLastSegmentColor(game),
        isFirst: false,
        isLast: true,
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(children: segments),
    );
  }

  Widget _buildSharpnessSegment(int value, Color color,
      {bool isFirst = false, bool isLast = false}) {
    if (value == 0) return const SizedBox.shrink();

    return Expanded(
      flex: value,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? Radius.circular(borderRadius) : Radius.zero,
            right: isLast ? Radius.circular(borderRadius) : Radius.zero,
          ),
        ),
      ),
    );
  }

  // Método auxiliar para obtener el valor del último segmento
  int _getLastSegmentValue() {
    if (sharpness.purple > 0) return sharpness.purple;
    if (sharpness.white > 0) return sharpness.white;
    if (sharpness.blue > 0) return sharpness.blue;
    if (sharpness.green > 0) return sharpness.green;
    if (sharpness.yellow > 0) return sharpness.yellow;
    if (sharpness.orange > 0) return sharpness.orange;
    if (sharpness.red > 0) return sharpness.red;
    return 0;
  }

  // Método auxiliar para obtener el color del último segmento
  Color _getLastSegmentColor(GameColors game) {
    if (sharpness.purple > 0) return game.sharpnessPurple;
    if (sharpness.white > 0) return game.sharpnessWhite;
    if (sharpness.blue > 0) return game.sharpnessBlue;
    if (sharpness.green > 0) return game.sharpnessGreen;
    if (sharpness.yellow > 0) return game.sharpnessYellow;
    if (sharpness.orange > 0) return game.sharpnessOrange;
    if (sharpness.red > 0) return game.sharpnessRed;
    return Colors.grey;
  }
}
