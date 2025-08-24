import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/monsters_api.dart';
import 'package:mhwilds_app/components/monster_details_card.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/widgets/custom_card.dart';

class MonsterDetails extends StatefulWidget {
  final int monsterId;

  const MonsterDetails({super.key, required this.monsterId});

  @override
  _MonsterDetailsState createState() => _MonsterDetailsState();
}

class _MonsterDetailsState extends State<MonsterDetails> {
  late Future<Monster> _monsterFuture;
  String selectedRank = 'low';
  bool isLowRankAvailable = false;
  bool isHighRankAvailable = false;

  @override
  void initState() {
    super.initState();
    _monsterFuture = MonstersApi.fetchMonsterById(widget.monsterId);
  }

  void checkAvailableRanks(Monster monster) {
    bool lowAvailable = false;
    bool highAvailable = false;

    for (var reward in monster.rewards) {
      for (var condition in reward.conditions) {
        if (condition.rank == 'low') lowAvailable = true;
        if (condition.rank == 'high') highAvailable = true;
      }
    }

    if (!lowAvailable && highAvailable) {
      selectedRank = 'high';
    } else if (!highAvailable && lowAvailable) {
      selectedRank = 'low';
    }

    isLowRankAvailable = lowAvailable;
    isHighRankAvailable = highAvailable;
  }

  void _onRankChanged(int index) {
    setState(() {
      selectedRank = index == 0 ? 'low' : 'high';
    });
  }

  // Sección de información básica del monstruo
  Widget _buildMonsterInfoSection(Monster monster) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldSoft.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldSoft.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Monster Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tipo y especie
          Row(
            children: [
              Expanded(
                child: _buildInfoRow('Type', monster.kind),
              ),
              Expanded(
                child: _buildInfoRow('Species', monster.species),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Descripción
          if (monster.description.isNotEmpty) ...[
            _buildInfoRow('Description', monster.description,
                isDescription: true),
            const SizedBox(height: 12),
          ],

          // Características
          if (monster.features.isNotEmpty) ...[
            _buildInfoRow('Features', monster.features, isDescription: true),
            const SizedBox(height: 12),
          ],

          // Consejos de caza
          if (monster.tips.isNotEmpty) ...[
            _buildInfoRow('Hunting Tips', monster.tips, isDescription: true),
            const SizedBox(height: 12),
          ],

          // Variantes del monstruo
          if (monster.variants.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        size: 20,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Monster Variants',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: monster.variants.map((variant) {
                      // Determinar si es tempered o arch-tempered
                      bool isTempered =
                          variant.kind.toLowerCase().contains('tempered') ||
                              variant.name.toLowerCase().contains('tempered');
                      bool isArchTempered = variant.kind
                              .toLowerCase()
                              .contains('arch-tempered') ||
                          variant.name.toLowerCase().contains('arch-tempered');

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
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: borderColor,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              variant.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: variantColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              variant.kind,
                              style: TextStyle(
                                fontSize: 12,
                                color: variantColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Sección de estadísticas
  Widget _buildStatsSection(Monster monster) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldSoft.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldSoft.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                    'Base Health', '${monster.baseHealth}', Icons.favorite),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                    'Size Range', _formatSizeRange(monster), Icons.height),
              ),
            ],
          ),
          if (monster.elements.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoRow('Elements', monster.elements.join(', ')),
          ],
        ],
      ),
    );
  }

  // Sección de debilidades y resistencias
  Widget _buildWeaknessesResistancesSection(Monster monster) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldSoft.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y ElementsInfo
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.goldSoft.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Weaknesses and Resistances',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              const Spacer(),
              // ElementsInfo a la derecha
              ElementsInfo(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildWeaknessesColumn(monster.weaknesses),
              ),
              if (monster.resistances.isNotEmpty) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: _buildResistancesColumn(monster.resistances),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Sección de partes rompibles
  Widget _buildBreakablePartsSection(Monster monster) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldSoft.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldSoft.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Breakable Parts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...monster.breakableParts.map(
            (part) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.construction, color: AppColors.goldSoft),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      part.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widgets auxiliares
  Widget _buildInfoRow(String label, String value,
      {bool isDescription = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isDescription ? 13 : 14,
            color: Colors.black54,
          ),
          softWrap: true,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.goldSoft.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldSoft.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.goldSoft, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaknessesColumn(List<Weakness> weaknesses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weaknesses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        ...weaknesses
            .where((w) => w.kind == 'element' && w.level == 1)
            .map((w) {
          final element = w.element ?? '';
          if (element.isEmpty) return const SizedBox.shrink();

          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Image.asset(
              'assets/imgs/elements/${element.toLowerCase()}.webp',
              height: 25,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResistancesColumn(List<Resistance> resistances) {
    // Filtrar solo las resistencias elementales que tienen elementos válidos
    final validResistances = resistances
        .where((r) => r.kind == 'element' && r.element.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resistances',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        if (validResistances.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              'No known resistances',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...validResistances.map((r) => Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/imgs/elements/${r.element.toLowerCase()}.webp',
                      height: 25,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      r.kind,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  String _formatSize(Monster monster) {
    // Usar el tamaño real del monstruo si está disponible, sino usar baseHealth como fallback
    if (monster.size != null) {
      final baseSize =
          monster.size!.base / 100; // Convertir de centímetros a metros
      return '${baseSize.toStringAsFixed(2)} m';
    } else {
      // Fallback: usar baseHealth como aproximación
      final baseSize = monster.baseHealth / 100;
      return '${baseSize.toStringAsFixed(2)} m';
    }
  }

  String _formatSizeRange(Monster monster) {
    // Mostrar el rango de tamaños mínimo y máximo
    if (monster.size != null) {
      final minSize =
          monster.size!.mini / 100; // Convertir de centímetros a metros
      final maxSize =
          monster.size!.gold / 100; // Usar corona de oro como máximo
      return '${minSize.toStringAsFixed(2)} - ${maxSize.toStringAsFixed(2)} m';
    } else {
      // Fallback: usar baseHealth como aproximación
      final baseSize = monster.baseHealth / 100;
      final minSize = baseSize * 0.9; // 10% menos que el base
      final maxSize = baseSize * 1.1; // 10% más que el base
      return '${minSize.toStringAsFixed(2)} - ${maxSize.toStringAsFixed(2)} m';
    }
  }

  Widget _buildSizeSection(Monster monster) {
    // Verificar si el monstruo tiene datos de tamaño
    if (monster.size == null) {
      return const SizedBox.shrink(); // No mostrar la sección si no hay datos
    }

    final sizes = monster.size!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldSoft.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldSoft.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Crown Sizes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tamaño base
          _buildSizeRow(
            'Base size',
            '${(sizes.base / 100).toStringAsFixed(2)} m',
            Icons.height,
            Colors.blue,
          ),
          const SizedBox(height: 8),

          // Mini crown
          _buildSizeRow(
            'Mini crown',
            '< ${(sizes.mini / 100).toStringAsFixed(2)} m',
            Icons.keyboard_arrow_down,
            Colors.green,
          ),
          const SizedBox(height: 8),

          // Silver crown
          _buildSizeRow(
            'Silver crown',
            '≥ ${(sizes.silver / 100).toStringAsFixed(2)} m',
            Icons.keyboard_arrow_up,
            Colors.grey[600]!,
          ),
          const SizedBox(height: 8),

          // Gold crown
          _buildSizeRow(
            'Gold crown',
            '≥ ${(sizes.gold / 100).toStringAsFixed(2)} m',
            Icons.keyboard_arrow_up,
            AppColors.goldSoft,
          ),
        ],
      ),
    );
  }

  Widget _buildSizeRow(String label, String size, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            size,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Monster>(
      future: _monsterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('No se encontró el monstruo')),
          );
        }

        final monster = snapshot.data!;
        checkAvailableRanks(monster);

        return Scaffold(
          appBar: AppBar(
            title: Text(monster.name),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag: monster.name,
                  child: Image.asset(
                    'assets/imgs/monsters/${monster.name.toLowerCase().replaceAll(' ', '_')}.png',
                    width: 380,
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 20),

                // Información básica del monstruo
                _buildMonsterInfoSection(monster),

                const SizedBox(height: 20),

                // Estadísticas y atributos
                _buildStatsSection(monster),

                const SizedBox(height: 20),

                // Tamaños de corona
                _buildSizeSection(monster),

                const SizedBox(height: 20),

                // Debilidades y resistencias
                _buildWeaknessesResistancesSection(monster),

                const SizedBox(height: 20),

                // Partes rompibles
                if (monster.breakableParts.isNotEmpty) ...[
                  _buildBreakablePartsSection(monster),
                  const SizedBox(height: 20),
                ],

                // Selector de rango para recompensas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ToggleButtons(
                    fillColor: AppColors.goldSoft,
                    borderRadius: BorderRadius.circular(10),
                    disabledColor: Colors.grey,
                    isSelected: [
                      selectedRank == 'low' && isLowRankAvailable,
                      selectedRank == 'high' && isHighRankAvailable,
                    ],
                    onPressed: (index) {
                      if ((index == 0 && isLowRankAvailable) ||
                          (index == 1 && isHighRankAvailable)) {
                        _onRankChanged(index);
                      }
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Low Rank',
                          style: TextStyle(
                            color:
                                isLowRankAvailable ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'High Rank',
                          style: TextStyle(
                            color: isHighRankAvailable
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: MonsterRewards(
                    rewards: monster.rewards,
                    selectedRank: selectedRank,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MonsterRewards extends StatelessWidget {
  final List<Reward> rewards;
  final String selectedRank;

  const MonsterRewards({
    super.key,
    required this.rewards,
    required this.selectedRank,
  });

  @override
  Widget build(BuildContext context) {
    List<Reward> filteredRewards = rewards
        .where((reward) => reward.conditions
            .any((condition) => condition.rank == selectedRank))
        .toList();

    return filteredRewards.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredRewards.length,
            itemBuilder: (context, index) {
              final reward = filteredRewards[index];

              var uniqueConditions = <String, RewardCondition>{};
              for (var condition in reward.conditions) {
                uniqueConditions[condition.kind] = condition;
              }

              var filteredConditions = uniqueConditions.values.toList();

              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldSoft.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.goldSoft.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetails(
                            item: reward.item,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header con nombre del material
                          Text(
                            reward.item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                          const SizedBox(height: 12),

                          // Lista de condiciones
                          ...filteredConditions.map<Widget>((condition) {
                            String formattedKind = condition.kind
                                .replaceAll('-', ' ')
                                .split(' ')
                                .map((word) =>
                                    word[0].toUpperCase() + word.substring(1))
                                .join(' ');

                            // Determinar si es tempered o arch-tempered
                            bool isTempered = condition.kind
                                .toLowerCase()
                                .contains('tempered');
                            bool isArchTempered = condition.kind
                                .toLowerCase()
                                .contains('arch-tempered');

                            // Colores según el tipo de condición
                            Color conditionColor;
                            Color borderColor;
                            Color backgroundColor;

                            if (isArchTempered) {
                              conditionColor = Colors.orange[700]!;
                              borderColor = Colors.orange.withOpacity(0.6);
                              backgroundColor = Colors.orange.withOpacity(0.1);
                            } else if (isTempered) {
                              conditionColor = Colors.purple[700]!;
                              borderColor = Colors.purple.withOpacity(0.6);
                              backgroundColor = Colors.purple.withOpacity(0.1);
                            } else {
                              conditionColor = Colors.grey[700]!;
                              borderColor = Colors.grey[200]!;
                              backgroundColor = Colors.grey[50]!;
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: borderColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Porcentaje destacado
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.goldSoft,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.goldSoft
                                              .withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      "${condition.chance}%",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Tipo de condición
                                  Expanded(
                                    child: Text(
                                      formattedKind,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: conditionColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : const SizedBox();
  }
}
