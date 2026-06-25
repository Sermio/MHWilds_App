import 'package:flutter/material.dart';

enum ListFilterFieldType { text, select, gridMenu, custom }

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

  const ListFilterFieldConfig.gridMenu({
    required this.id,
    required this.label,
    required this.value,
    required this.onSelectChanged,
    required this.options,
    this.allLabel,
    this.includeAllOption = true,
  })  : type = ListFilterFieldType.gridMenu,
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
    this.maxHeight,
    this.dropdownMenuMaxHeight = 280,
  });

  final String title;
  final String resetLabel;
  final VoidCallback onReset;
  final List<ListFilterFieldConfig> fields;
  final double? maxHeight;
  final double dropdownMenuMaxHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final header = Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 12, 0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
    );

    final fieldsContent = SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
    );

    return Material(
      color: colorScheme.surface,
      child: maxHeight != null
          ? ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  header,
                  Flexible(child: fieldsContent),
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                header,
                fieldsContent,
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
        else if (field.type == ListFilterFieldType.gridMenu)
          _buildGridMenuField(context, field)
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

  Widget _buildGridMenuField(BuildContext context, ListFilterFieldConfig field) {
    return _GridMenuWidget(
      field: field,
      allLabel: field.allLabel ?? _localizedAllLabel(context),
    );
  }
}

class _GridMenuWidget extends StatefulWidget {
  final ListFilterFieldConfig field;
  final String allLabel;

  const _GridMenuWidget({required this.field, required this.allLabel});

  @override
  State<_GridMenuWidget> createState() => _GridMenuWidgetState();
}

class _GridMenuWidgetState extends State<_GridMenuWidget> {
  final MenuController _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final field = widget.field;
    final allLabel = widget.allLabel;

    return MenuAnchor(
      controller: _controller,
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(colorScheme.surface),
        elevation: WidgetStateProperty.all(8),
        padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      builder: (context, controller, child) {
        final selectedOption = field.options.firstWhere(
          (opt) => opt.value == field.value,
          orElse: () => ListFilterOption(value: null, label: allLabel),
        );

        return InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
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
              suffixIcon: Icon(
                controller.isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            isEmpty: false,
            child: Row(
              children: [
                if (selectedOption.leading != null) ...[
                  selectedOption.leading!,
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    selectedOption.label,
                    style: TextStyle(color: colorScheme.onSurface),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      menuChildren: [
        Container(
          width: 280,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (field.includeAllOption) ...[
                InkWell(
                  onTap: () {
                    field.onSelectChanged?.call(null);
                    _controller.close();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: field.value == null
                          ? colorScheme.primaryContainer.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      allLabel,
                      style: TextStyle(
                        fontWeight: field.value == null ? FontWeight.bold : FontWeight.normal,
                        color: field.value == null ? colorScheme.primary : colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: field.options.map((option) {
                  final isSelected = field.value == option.value;
                  return SizedBox(
                    width: 128,
                    child: InkWell(
                      onTap: () {
                        field.onSelectChanged?.call(option.value);
                        _controller.close();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primaryContainer.withOpacity(0.5)
                              : colorScheme.surfaceContainerHighest.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? colorScheme.primary : colorScheme.outlineVariant.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (option.leading != null) ...[
                              option.leading!,
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                option.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
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
