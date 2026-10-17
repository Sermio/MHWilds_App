import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/c_appbar.dart';
import 'package:mhwilds_app/components/c_drawer.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/screens/app_section.dart';
import 'package:mhwilds_app/utils/review_service.dart';
import 'package:mhwilds_app/utils/update_checker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppSection _section = AppSection.monsters;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ReviewService.trackOpening();
      if (!mounted) return;
      await AppUpdateChecker.checkAndShowUpdateDialog(context);
      if (!mounted) return;
      await ReviewService.checkAndShowReview(context);
    });
  }

  void _changeSection(AppSection section) {
    setState(() => _section = section);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Cappbar(
        title: _section.title(AppLocalizations.of(context)!),
        actions: _section.appBarActions(context),
      ),
      drawer: Cdrawer(
        onSectionSelected: _changeSection,
        selectedSection: _section,
      ),
      body: _section.screen,
    );
  }
}
