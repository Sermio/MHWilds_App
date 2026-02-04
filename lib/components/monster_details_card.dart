import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/c_chip.dart';
import 'package:mhwilds_app/components/elements_dialog.dart';
import 'package:mhwilds_app/data/ailments.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/map_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/utils.dart';

class MonsterDetailsCard extends StatelessWidget {
  final Monster monster;

  const MonsterDetailsCard({super.key, required this.monster});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Type: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface),
                ),
                Text(
                  monster.kind,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Species: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface),
                ),
                Text(
                  monster.species,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Divider(
              color: colorScheme.outline,
            ),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MonsterAttributes(
                      attributeType: "Elements",
                      children: monster.elements
                          .where((w) => w.isNotEmpty)
                          .map(
                            (w) => Image.asset(
                              'assets/imgs/elements/${w.toLowerCase()}.webp',
                              height: 25,
                            ),
                          )
                          .toList(),
                    ),
                    MonsterAttributes(
                      attributeType: "Ailments",
                      children: monster.ailments
                          .where((w) => w.name.isNotEmpty)
                          .map(
                            (w) => Image.asset(
                              'assets/imgs/elements/${w.name.toLowerCase()}.webp',
                              height: 25,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                const Positioned(right: 10, child: ElementsInfo()),
              ],
            ),
            const SizedBox(height: 15),
            // Variantes del monstruo (incluyendo tempered)
            if (monster.variants.isNotEmpty) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber,
                          size: 16,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Variants Available:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      alignment: WrapAlignment.center,
                      children: monster.variants.map((variant) {
                        // Determinar si es tempered o arch-tempered
                        bool isTempered =
                            variant.kind.toLowerCase().contains('tempered') ||
                                variant.name.toLowerCase().contains('tempered');
                        bool isArchTempered = variant.kind
                                .toLowerCase()
                                .contains('arch-tempered') ||
                            variant.name
                                .toLowerCase()
                                .contains('arch-tempered');

                        // Colores según el tipo de variante
                        Color variantColor;
                        Color borderColor;
                        Color backgroundColor;

                        if (isArchTempered) {
                          variantColor = Colors.orange[700]!;
                          borderColor = Colors.orange.withOpacity(0.6);
                          backgroundColor = Colors.orange.withOpacity(0.1);
                        } else if (isTempered) {
                          variantColor = Colors.purple[700]!;
                          borderColor = Colors.purple.withOpacity(0.6);
                          backgroundColor = Colors.purple.withOpacity(0.1);
                        } else {
                          variantColor = Colors.blue[700]!;
                          borderColor = Colors.blue.withOpacity(0.6);
                          backgroundColor = Colors.blue.withOpacity(0.1);
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            variant.name,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: variantColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MonsterAttributes(
                  attributeType: "Weaknesses",
                  children: monster.weaknesses
                      .where((w) =>
                          w.kind == 'element' &&
                          w.element != null &&
                          w.element!.isNotEmpty)
                      .map((w) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/imgs/elements/${w.element!.toLowerCase()}.webp',
                            height: 25,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                MonsterAttributes(
                  attributeType: "Resistances",
                  children: monster.resistances
                      .where((w) => w.kind == 'element' && w.element.isNotEmpty)
                      .map(
                        (w) => Image.asset(
                          'assets/imgs/elements/${w.element.toLowerCase()}.webp',
                          height: 25,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            if (monster.locations.isNotEmpty) const SizedBox(height: 15),
            if (monster.locations.isNotEmpty)
              Divider(
                color: colorScheme.outline,
              ),
            if (monster.locations.isNotEmpty)
              Text(
                'Locations',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
            if (monster.locations.isNotEmpty)
              const SizedBox(
                height: 15,
              ),
            if (monster.locations.isNotEmpty)
              Wrap(
                spacing: 8.0,
                runSpacing: 2.0,
                children: monster.locations.asMap().entries.map((location) {
                  int index = location.key;
                  String loc = location.value.name;
                  return Bounce(
                    from: 10,
                    delay: Duration(milliseconds: index * 150),
                    child: Cchip(
                      itemName: loc,
                      itemIdForColor: location.value.id,
                      getItemColor: zoneBackgroundColor,
                      optionalWidget: Image.asset(
                        'assets/imgs/maps/map.png',
                        width: 16,
                        height: 16,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MonsterMapDetails(mapId: location.value.id),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            if (monster.tips != "")
              const SizedBox(
                height: 15,
              ),
            if (monster.tips != "")
              Divider(
                color: colorScheme.outline,
              ),
            if (monster.tips != "")
              Text(
                'Tips',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
            if (monster.tips != "")
              const SizedBox(
                height: 15,
              ),
            if (monster.tips != "")
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
                child: Wrap(
                  children: [
                    Text(monster.tips),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ElementsInfo extends StatelessWidget {
  const ElementsInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        Icons.info_outline,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const ElementsDialog(),
        );
      },
    );
  }
}

class ElementsAndAilments extends StatelessWidget {
  const ElementsAndAilments({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView.builder(
      itemCount: ailments.length,
      itemBuilder: (context, index) {
        String ailmentName = ailments[index].keys.first;
        String description = ailments[index][ailmentName] ?? "";

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Image.asset(
                        'assets/imgs/elements/${ailmentName.toLowerCase()}.webp',
                        height: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        ailmentName
                            .replaceAll('-', ' ')
                            .split(' ')
                            .map((word) =>
                                word[0].toUpperCase() + word.substring(1))
                            .join(' '),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      color: colorScheme.onSurface,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MonsterAttributes extends StatelessWidget {
  const MonsterAttributes({
    super.key,
    required this.attributeType,
    required this.children,
  });

  final String attributeType;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final hasContent = children != null && children!.isNotEmpty;

    return Column(
      children: [
        Text(
          attributeType,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        hasContent
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children!,
              )
            : const SizedBox(
                height: 25,
                child: Center(child: Text("-")),
              ),
      ],
    );
  }
}

Widget attributeIconWithText(String imageName, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Column(
      children: [
        Image.asset(
          'assets/imgs/elements/${imageName.toLowerCase()}.webp',
          height: 25,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    ),
  );
}
