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
        // Creamos un widget dentro del overlay
        return Positioned(
          left: position.dx, // Posición X calculada en el controlador
          top: position.dy, // Posición Y calculada en el controlador
          child: Container(
            padding: const EdgeInsets.all(16), // Espaciado interno
            constraints: const BoxConstraints(
              maxWidth: 300, // Ancho máximo del contenedor
            ),
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo
              borderRadius: BorderRadius.circular(12), // Bordes redondeados
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Sombra del contenedor
                  blurRadius: 8, // Difusión de la sombra
                  offset: const Offset(0, 4), // Desplazamiento de la sombra
                ),
              ],
            ),
            child:
                content, // Se coloca el contenido dinámico dentro del contenedor
          ),
        );
      },
    );
  }
}
