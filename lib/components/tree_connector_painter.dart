import 'package:flutter/material.dart';

class TreeConnectorPainter extends CustomPainter {
  final bool isLastChild;
  final Color color;

  TreeConnectorPainter({
    required this.isLastChild,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Queremos que la línea empiece un poco desplazada hacia la izquierda,
    // o justo en el centro del espacio disponible.
    final double lineX = size.width / 2;
    final double halfHeight = size.height / 2;

    // Línea vertical desde arriba hasta la mitad
    canvas.drawLine(Offset(lineX, 0), Offset(lineX, halfHeight), paint);

    // Línea horizontal desde el centro hacia la derecha
    canvas.drawLine(Offset(lineX, halfHeight), Offset(size.width, halfHeight), paint);

    // Si no es el último hijo, continuamos la línea vertical hasta abajo
    if (!isLastChild) {
      canvas.drawLine(Offset(lineX, halfHeight), Offset(lineX, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant TreeConnectorPainter oldDelegate) {
    return oldDelegate.isLastChild != isLastChild || oldDelegate.color != color;
  }
}

class StraightLinePainter extends CustomPainter {
  final Color color;

  StraightLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double lineX = size.width / 2;
    canvas.drawLine(Offset(lineX, 0), Offset(lineX, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant StraightLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
