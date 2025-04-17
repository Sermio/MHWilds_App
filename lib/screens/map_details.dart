import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/models/location.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';

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
        name: 'Unknown Map',
        gameId: 0,
        zoneCount: 0,
        camps: [],
      ),
    );
    loadImages(mapData!.name);
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
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: InteractiveViewer(
              maxScale: double.infinity,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCampList(int floor) {
    final campsOnFloor =
        mapData?.camps!.where((camp) => camp.floor == floor).toList() ?? [];
    if (campsOnFloor.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: campsOnFloor.map((camp) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.cabin_rounded),
              title: Text(camp.name!),
              subtitle: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(
                      text: 'Risk: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${camp.risk}'),
                    const TextSpan(
                      text: '  |  Zone: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${camp.zone}'),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(mapData?.name ?? 'Map'),
      ),
      body: isLoadingImages
          ? const Center(child: CircularProgressIndicator())
          : imageFiles.isEmpty
              ? const Center(child: Text('No images found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: imageFiles.asMap().entries.map((entry) {
                      int index = entry.key;
                      String image = entry.value;
                      int floorIndex = index;
                      int levelLabel = index + 1;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Level $levelLabel:',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _showFullImage(context, image),
                              child: FadeIn(
                                duration: const Duration(milliseconds: 800),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(image),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildCampList(floorIndex),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
