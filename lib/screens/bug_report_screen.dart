import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/bug_report_service.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({super.key});

  @override
  State<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  final _description = TextEditingController();
  final _contact = TextEditingController();
  final _files = <PlatformFile>[];
  bool _sending = false;
  bool _showError = false;

  @override
  void dispose() {
    _description.dispose();
    _contact.dispose();
    super.dispose();
  }

  void _snack(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  Future<void> _pick() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await FilePicker.platform
        .pickFiles(type: FileType.media, allowMultiple: true);
    if (result == null || !mounted) return;
    final merged = [..._files, ...result.files.where((f) => f.path != null)];
    final issue =
        BugReportService.validateAttachments(merged.map((f) => f.size).toList());
    if (issue != null) {
      _snack(issue == AttachmentIssue.tooMany
          ? l10n.bugReportTooMany(BugReportService.maxFiles)
          : l10n.bugReportTooLarge(BugReportService.maxTotalMb));
      return;
    }
    setState(() => _files
      ..clear()
      ..addAll(merged));
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context)!;
    if (_description.text.trim().isEmpty) {
      setState(() => _showError = true);
      return;
    }
    setState(() => _sending = true);
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    final ok = await BugReportService.send(
      description: _description.text,
      contact: _contact.text,
      filePaths: _files.map((f) => f.path!).toList(),
      meta: {
        'app_version': '${info.version}+${info.buildNumber}',
        'platform':
            '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
        'locale': Localizations.localeOf(context).toLanguageTag(),
      },
    );
    if (!mounted) return;
    if (ok) {
      _snack(l10n.bugReportSent);
      Navigator.pop(context);
    } else {
      setState(() => _sending = false);
      _snack(l10n.bugReportFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportBug), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextField(
            controller: _description,
            enabled: !_sending,
            minLines: 5,
            maxLines: 10,
            maxLength: BugReportService.maxDescriptionLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.bugReportDescriptionLabel,
              hintText: l10n.bugReportDescriptionHint,
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
              errorText: _showError && _description.text.trim().isEmpty
                  ? l10n.bugReportDescriptionRequired
                  : null,
            ),
            onChanged: (_) {
              if (_showError) setState(() => _showError = false);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _contact,
            enabled: !_sending,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.bugReportContactLabel,
              helperText: l10n.bugReportContactHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: _sending || _files.length >= BugReportService.maxFiles
                ? null
                : _pick,
            icon: const Icon(Icons.attach_file),
            label: Text(l10n.bugReportAttach),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l10n.bugReportAttachLimit(
                  BugReportService.maxFiles, BugReportService.maxTotalMb),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          for (final file in _files)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.insert_drive_file_outlined),
              title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle:
                  Text('${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                tooltip: l10n.bugReportRemoveAttachment,
                onPressed: _sending ? null : () => setState(() => _files.remove(file)),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: _sending ? null : _send,
            icon: _sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            label: Text(_sending ? l10n.bugReportSending : l10n.bugReportSend),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.bugReportPrivacy,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
