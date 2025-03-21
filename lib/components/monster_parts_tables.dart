import 'package:flutter/material.dart';

class MonsterTable extends StatelessWidget {
  const MonsterTable(
      {super.key,
      required this.rank,
      required this.columnsTitles,
      required this.materials});

  final String rank;
  final List<String> columnsTitles;
  final List<Map<String, String>> materials;

  @override
  Widget build(BuildContext context) {
    return materials.isNotEmpty
        ? Column(
            children: [
              const SizedBox(
                width: 150,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Text(
                rank,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 150,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: _buildColumns(columnsTitles),
                  rows: _buildRows(columnsTitles),
                  // dataRowHeight: 60,
                  // dataRowMinHeight: 10,
                  dataRowMaxHeight: 60,
                  // headingRowHeight: 40,
                  // horizontalMargin: 0,
                  columnSpacing: 20,
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  List<DataColumn> _buildColumns(List<String> columnsTitles) {
    return columnsTitles
        .map((title) => DataColumn(
              label: Text(
                title.replaceAll(' ', '\n'),
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ))
        .toList();
  }

  List<DataRow> _buildRows(List<String> columnsTitles) {
    List<DataRow> rows = [];

    for (var material in materials) {
      List<DataCell> cells = [];

      for (var key in columnsTitles) {
        String value = material[key] ?? "-";
        cells.add(
          DataCell(
            SingleChildScrollView(
              child: Text(
                value.replaceAll(' ', '\n'),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }

      rows.add(DataRow(cells: cells));
    }

    return rows;
  }
}
