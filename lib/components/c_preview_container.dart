import 'package:flutter/material.dart';

// Asegúrate de que este import esté presente si utilizas un controlador de overlay
// import 'package:your_project_name/utils/overlay_controller.dart';

class CcontainerPreview extends StatelessWidget {
  const CcontainerPreview({
    super.key,
    required this.overlayPortalController, // Controlador para manejar el overlay
    required this.position, // Posición del overlay
    required this.content, // Contenido que se muestra en el overlay
  });

  final OverlayPortalController
      overlayPortalController; // Tu controlador para el overlay
  final Offset position; // La posición donde se debe mostrar el overlay
  final Widget? content; // El contenido que será mostrado dentro del overlay

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller:
          overlayPortalController, // Pasamos el controlador al OverlayPortal
      overlayChildBuilder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Positioned(
          left: position.dx,
          top: position.dy,
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: content,
          ),
        );
      },
    );
  }
}
