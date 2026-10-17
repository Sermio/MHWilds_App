import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/announcements_button.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/screens/app_section.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

class Cdrawer extends StatelessWidget {
  final ValueChanged<AppSection> onSectionSelected;
  final AppSection selectedSection;

  const Cdrawer({
    super.key,
    required this.onSectionSelected,
    required this.selectedSection,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
          ),
          child: Column(
            children: [
              menuHeader(context),
              Expanded(child: SingleChildScrollView(child: menuItems(context))),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Theme.of(context).colorScheme.onSurface;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        border: Border(
          bottom: BorderSide(
            color:
                (isDark ? Colors.black : Colors.white).withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldSoft.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, AppSpacing.lg, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 92,
                  height: 92,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.black : Colors.white)
                        .withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: (isDark ? Colors.black : Colors.white)
                          .withValues(alpha: 0.55),
                      width: 1,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.3 : 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset('assets/imgs/drawer/logo512.png',
                          fit: BoxFit.cover, excludeFromSemantics: true),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mismo ancho que el botón: el nombre queda centrado.
                  const SizedBox(width: 48),
                  Flexible(
                    child: Text(
                      l10n.appTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  AnnouncementsButton(color: accentColor),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 56,
                height: 3,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl),
      child: Column(
        children: [
          for (final section in AppSection.values) ...[
            if (section != AppSection.values.first) const SizedBox(height: 6),
            _buildMenuItem(
              context: context,
              title: section.title(l10n),
              leadingIcon: section.menuLeading(context),
              icon: section.icon,
              iconColor: section.iconColor(context),
              isSelected: selectedSection == section,
              onTap: () => onSectionSelected(section),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isSelected,
    Widget? leadingIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primary.withValues(alpha: 0.12)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.35)
              : colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: leadingIcon ??
                        Icon(
                          icon,
                          color: iconColor,
                          size: 28,
                        ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Texto del menú
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                // Flecha de navegación
                Icon(
                  Icons.arrow_forward_ios,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
