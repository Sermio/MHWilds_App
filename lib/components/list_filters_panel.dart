import 'package:flutter/material.dart';

enum ListFilterFieldType { text, select, custom }

class ListFilterOption {
  const ListFilterOption({
    required this.value,
    required this.label,
    this.leading,
  });

  final dynamic value;
  final String label;
  final Widget? leading;
}

class ListFilterFieldConfig {
  const ListFilterFieldConfig.text({
    required this.id,
    required this.label,
    required this.controller,
    required this.onTextChanged,
    this.hintText,
    this.prefixIcon,
  })  : type = ListFilterFieldType.text,
        value = null,
        onSelectChanged = null,
        options = const [],
        allLabel = null,
        includeAllOption = false,
        customBuilder = null;

  const ListFilterFieldConfig.select({
    required this.id,
    required this.label,
    required this.value,
    required this.onSelectChanged,
    required this.options,
    this.allLabel,
    this.includeAllOption = true,
  })  : type = ListFilterFieldType.select,
        controller = null,
        onTextChanged = null,
        hintText = null,
        prefixIcon = null,
        customBuilder = null;

  const ListFilterFieldConfig.custom({
    required this.id,
    required this.label,
    required this.customBuilder,
  })  : type = ListFilterFieldType.custom,
        controller = null,
        onTextChanged = null,
        hintText = null,
        prefixIcon = null,
        value = null,
        onSelectChanged = null,
        options = const [],
        allLabel = null,
        includeAllOption = false;

  final String id;
  final String label;
  final ListFilterFieldType type;

  final TextEditingController? controller;
  final ValueChanged<String>? onTextChanged;
  final String? hintText;
  final Widget? prefixIcon;

  final dynamic value;
  final ValueChanged<dynamic>? onSelectChanged;
  final List<ListFilterOption> options;
  final bool includeAllOption;
  final String? allLabel;
  final WidgetBuilder? customBuilder;
}

class ListFiltersPanel extends StatelessWidget {
  const ListFiltersPanel({
    super.key,
    required this.title,
    required this.resetLabel,
    required this.onReset,
    required this.fields,
    this.height = 350,
    this.dropdownMenuMaxHeight = 280,
  });

  final String title;
  final String resetLabel;
  final VoidCallback onReset;
  final List<ListFilterFieldConfig> fields;
  final double height;
  final double dropdownMenuMaxHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      height: height,
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.filter_list, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(resetLabel),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < fields.length; i++) ...[
                    _buildField(context, fields[i]),
                    if (i != fields.length - 1) const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, ListFilterFieldConfig field) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        if (field.type == ListFilterFieldType.text)
          _buildTextField(context, field)
        else if (field.type == ListFilterFieldType.select)
          _buildSelectField(context, field)
        else
          field.customBuilder!(context),
      ],
    );
  }

  Widget _buildTextField(BuildContext context, ListFilterFieldConfig field) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: field.controller,
      onChanged: field.onTextChanged,
      decoration: InputDecoration(
        hintText: field.hintText,
        prefixIcon: field.prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _buildSelectField(BuildContext context, ListFilterFieldConfig field) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = <DropdownMenuItem<dynamic>>[];
    final allLabel = field.allLabel ?? _localizedAllLabel(context);

    if (field.includeAllOption) {
      items.add(
        DropdownMenuItem<dynamic>(
          value: null,
          child: Text(
            allLabel,
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
      );
    }

    items.addAll(
      field.options.map(
        (option) => DropdownMenuItem<dynamic>(
          value: option.value,
          child: Row(
            children: [
              if (option.leading != null) ...[
                option.leading!,
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  option.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return DropdownButtonFormField<dynamic>(
      value: field.value,
      isExpanded: true,
      menuMaxHeight: dropdownMenuMaxHeight,
      items: items,
      onChanged: field.onSelectChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
      ),
    );
  }

  String _localizedAllLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode.toLowerCase();
    switch (locale) {
      case 'es':
        return 'Todos';
      case 'pt':
        return 'Todos';
      case 'fr':
        return 'Tous';
      case 'it':
        return 'Tutti';
      case 'de':
        return 'Alle';
      case 'pl':
        return 'Wszystkie';
      default:
        return 'All';
    }
  }
}
