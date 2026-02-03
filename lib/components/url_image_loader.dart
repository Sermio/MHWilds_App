import 'package:flutter/material.dart';

class UrlImageLoader extends StatelessWidget {
  final String itemName;
  final bool animate;
  final Future<String?> Function(String) loadImageUrlFunction;

  const UrlImageLoader({
    super.key,
    required this.itemName,
    required this.loadImageUrlFunction,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: loadImageUrlFunction(itemName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: double.infinity,
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return _errorWidget(context);
        } else {
          return Image.network(
            snapshot.data!,
            fit: BoxFit.contain,
            width: double.infinity,
            height: 200,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                width: double.infinity,
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) => _errorWidget(context),
          );
        }
      },
    );
  }

  Widget _errorWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "https://monsterhunterworld.wiki.fextralife.com/file/Monster-Hunter-World/canteen-monster-hunter-world-wiki-locations-npcs-felynes-skills.jpg"),
          fit: BoxFit.contain,
        ),
      ),
      child: Center(
        child: Text(
          "Image not found, but here's some food!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inverseSurface,
            shadows: [
              Shadow(
                  offset: Offset(1.0, 1.0),
                  color: Theme.of(context).colorScheme.shadow),
              Shadow(
                  offset: Offset(-1.0, 1.0),
                  color: Theme.of(context).colorScheme.shadow),
              Shadow(
                  offset: Offset(1.0, -1.0),
                  color: Theme.of(context).colorScheme.shadow),
              Shadow(
                  offset: Offset(-1.0, -1.0),
                  color: Theme.of(context).colorScheme.shadow),
            ],
          ),
        ),
      ),
    );
  }
}
