import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MonsterMapDetails extends StatefulWidget {
  const MonsterMapDetails({super.key, required this.map});

  final String map;

  @override
  State<MonsterMapDetails> createState() => _MonsterMapDetailsState();
}

class _MonsterMapDetailsState extends State<MonsterMapDetails> {
  List<String> imageFiles = [];
  bool isLoading = true; // Nuevo estado para controlar el loader

  @override
  void initState() {
    super.initState();
    loadImages(widget.map);
  }

  Future<void> loadImages(String map) async {
    List<String> loadedImages = [];
    String folder = map.toLowerCase().replaceAll(' ', '_');
    String baseName = folder.replaceAll("'", '_');

    int index = 1;
    while (true) {
      String assetPath = 'assets/imgs/maps/$folder/$baseName$index.png';

      print("Intentando cargar: $assetPath");
      try {
        await rootBundle.load(assetPath);
        loadedImages.add(assetPath);
        index++;
      } catch (e) {
        print("No se encontró: $assetPath, terminando carga.");
        break;
      }
    }

    setState(() {
      imageFiles = loadedImages;
      isLoading = false; // Desactiva el loader
    });

    print("Imágenes cargadas: $imageFiles");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.map} Details')),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Muestra el loader
          : imageFiles.isEmpty
              ? const Center(child: Text('No images found'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: imageFiles.asMap().entries.map((entry) {
                      int index = entry.key;
                      String image = entry.value;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Column(
                          children: [
                            Text('Level ${index + 1}:',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _showFullImage(context, image),
                              child: FadeIn(
                                  duration: const Duration(milliseconds: 800),
                                  child: Image.asset(image)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
