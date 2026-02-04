import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/models/location.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';

class MonsterMapDetails extends StatefulWidget {
  const MonsterMapDetails({super.key, required this.mapId});
  final int mapId;

  @override
  State<MonsterMapDetails> createState() => _MonsterMapDetailsState();
}

class _MonsterMapDetailsState extends State<MonsterMapDetails> {
  List<String> imageFiles = [];
  bool isLoadingImages = true;
  MapData? mapData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LocationsProvider>(context, listen: false);
      if (!provider.hasData) {
        provider.fetchZones().then((_) => _initMapData(provider));
      } else {
        _initMapData(provider);
      }
    });
  }

  void _initMapData(LocationsProvider provider) {
    mapData = provider.zones.firstWhere(
      (element) => element.id == widget.mapId,
      orElse: () => MapData(
        id: widget.mapId,
        name: AppLocalizations.of(context)!.unknownMap,
        gameId: 0,
        zoneCount: 0,
        camps: [],
      ),
    );
    // Obtener el nombre en inglés del mapa para cargar las imágenes
    final enNamesCache = Provider.of<EnNamesCache>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final englishMapName = enNamesCache.nameForMapImage(
          widget.mapId,
          mapData!.name ?? l10n.unknownMap,
        ) ??
        mapData!.name ??
        l10n.unknownMap;
    loadImages(englishMapName);
  }

  Future<void> loadImages(String? mapName) async {
    List<String> loadedImages = [];
    String folder =
        mapName!.toLowerCase().replaceAll(' ', '_').replaceAll("'", '_');
    String baseName = folder;

    int index = 1;
    while (true) {
      String assetPath = 'assets/imgs/maps/$folder/$baseName$index.png';
      try {
        await rootBundle.load(assetPath);
        loadedImages.add(assetPath);
        index++;
      } catch (_) {
        break;
      }
    }

    setState(() {
      imageFiles = loadedImages;
      isLoadingImages = false;
    });
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            // Área transparente que se puede tocar para cerrar
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.transparent),
              ),
            ),
            // Imagen centrada con zoom que NO se puede tocar para cerrar
            Center(
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para asignar colores según el nivel de riesgo
  Color _getRiskColor(String? risk) {
    if (risk == null) return Colors.grey;

    String riskLower = risk.toLowerCase().trim();

    // Riesgos bajos - Verde
    if (riskLower.contains('low') ||
        riskLower.contains('bajo') ||
        riskLower == '1' ||
        riskLower == 'safe' ||
        riskLower == 'seguro') {
      return Colors.green;
    }

    // Riesgos medios - Amarillo/Naranja
    if (riskLower.contains('medium') ||
        riskLower.contains('medio') ||
        riskLower == '2' ||
        riskLower == 'moderate' ||
        riskLower == 'moderado') {
      return Colors.orange;
    }

    // Riesgos altos - Rojo
    if (riskLower.contains('high') ||
        riskLower.contains('alto') ||
        riskLower == '3' ||
        riskLower == 'dangerous' ||
        riskLower == 'peligroso') {
      return Colors.red;
    }

    // Riesgos extremos - Púrpura
    if (riskLower.contains('extreme') ||
        riskLower.contains('extremo') ||
        riskLower == '4' ||
        riskLower == 'deadly' ||
        riskLower == 'letal') {
      return Colors.purple;
    }

    // Riesgos especiales - Azul
    if (riskLower.contains('special') ||
        riskLower.contains('especial') ||
        riskLower.contains('unique') ||
        riskLower.contains('único')) {
      return Colors.blue;
    }

    // Por defecto - Gris
    return Colors.grey;
  }

  Widget _buildCampList(int floor) {
    final colorScheme = Theme.of(context).colorScheme;
    final campsOnFloor =
        mapData?.camps!.where((camp) => camp.floor == floor).toList() ?? [];
    if (campsOnFloor.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppLocalizations.of(context)!.campsOfLevel(floor + 1),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
        ...campsOnFloor.map((camp) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.cabin_rounded,
                        color: colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            camp.name!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildInfoChip(
                                AppLocalizations.of(context)!.risk,
                                '${camp.risk}',
                                _getRiskColor(camp.risk),
                              ),
                              const SizedBox(width: 12),
                              _buildInfoChip(
                                AppLocalizations.of(context)!.zone,
                                '${camp.zone}',
                                colorScheme.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text(mapData?.name ?? AppLocalizations.of(context)!.map),
        centerTitle: true,
        elevation: 10,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: isLoadingImages
          ? Container(
              height: 200,
              margin: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.loadingMap,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : imageFiles.isEmpty
              ? Container(
                  height: 200,
                  margin: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 64,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noMapImagesFound,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: imageFiles.asMap().entries.map((entry) {
                      int index = entry.key;
                      String image = entry.value;
                      int floorIndex = index;
                      int levelLabel = index + 1;

                      return FadeInUp(
                        duration: Duration(milliseconds: 600 + (index * 200)),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.lerp(colorScheme.primary,
                                        Colors.black, 0.45),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    '${AppLocalizations.of(context)!.level} $levelLabel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () => _showFullImage(context, image),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.shadow
                                              .withOpacity(0.2),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildCampList(floorIndex),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
