import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';

class MonsterTable extends StatefulWidget {
  const MonsterTable(
      {super.key,
      required this.rank,
      required this.columnsTitles,
      required this.materials});

  final String rank;
  final List<String> columnsTitles;
  final List<Map<String, String>> materials;

  @override
  State<MonsterTable> createState() => _MonsterTableState();
}

class _MonsterTableState extends State<MonsterTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.materials.isNotEmpty
        ? Column(
            children: [
              const SizedBox(
                width: 150,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Text(
                widget.rank,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 150,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                scrollbarOrientation: ScrollbarOrientation.top,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: _buildColumns(widget.columnsTitles),
                    rows: _buildRows(widget.columnsTitles),
                    dataRowMaxHeight: 60,
                    columnSpacing: 20,
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  List<DataColumn> _buildColumns(List<String> columnsTitles) {
    return columnsTitles.map((title) {
      return DataColumn(
        label: Text(
          title.replaceAll(' ', '\n'),
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      );
    }).toList();
  }

  List<DataRow> _buildRows(List<String> columnsTitles) {
    List<DataRow> rows = [];

    for (var material in widget.materials) {
      List<DataCell> cells = [];

      for (var key in columnsTitles) {
        String value = material[key] ?? "-";
        const MaterialImage(
          materialName: 'Poison Sac',
        );
        if (key == 'Image') {
          cells.add(DataCell(
            SizedBox(
              width: 50,
              height: 50,
              child: MaterialImage(
                materialName: material['Material'] ?? '',
              ),
            ),
          ));
        } else {
          cells.add(DataCell(
            SingleChildScrollView(
              child: Text(
                value.replaceAll(' ', '\n'),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ));
        }
      }

      rows.add(DataRow(cells: cells));
    }

    return rows;
  }
}
