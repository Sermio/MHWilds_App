import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class BuildOptimizerScreen extends StatefulWidget {
  const BuildOptimizerScreen({super.key});

  @override
  State<BuildOptimizerScreen> createState() => _BuildOptimizerScreenState();
}

class _BuildOptimizerScreenState extends State<BuildOptimizerScreen> {
  static final Uri _optimizerUri = Uri.parse('https://mh-opti.nenri.fr/');

  late final bool _isWebViewSupported;
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasSyncedPreferences = false;

  @override
  void initState() {
    super.initState();
    _isWebViewSupported = _supportsWebView();
    if (_isWebViewSupported) {
      _controller = _createController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              if (!mounted) return;
              setState(() => _isLoading = true);
            },
            onPageFinished: (_) {
              if (!mounted) return;
              _syncWebViewPreferences();
              setState(() => _isLoading = false);
            },
          ),
        )
        ..loadRequest(_optimizerUri);
    } else {
      _isLoading = false;
    }
  }

  WebViewController _createController() {
    final controller = WebViewController.fromPlatformCreationParams(
      const PlatformWebViewControllerCreationParams(),
    );

    final platformController = controller.platform;
    if (platformController is AndroidWebViewController) {
      platformController.setOnShowFileSelector((params) async {
        final allowMultiple = switch (params.mode) {
          FileSelectorMode.openMultiple => true,
          _ => false,
        };

        final result = await FilePicker.platform.pickFiles(
          allowMultiple: allowMultiple,
        );

        final paths = result?.paths.whereType<String>().toList() ?? const [];
        return paths.map((p) => Uri.file(p).toString()).toList();
      });
    }

    return controller;
  }

  void _syncWebViewPreferences() {
    if (!mounted || _controller == null || _hasSyncedPreferences) return;
    _hasSyncedPreferences = true;
    final brightness = Theme.of(context).brightness;
    final locale = Localizations.localeOf(context);
    final langKey = locale.countryCode != null
        ? '${locale.languageCode.toLowerCase()}-${locale.countryCode!.toUpperCase()}'
        : locale.languageCode.toLowerCase();
    final themeMode = brightness == Brightness.dark ? 'dark' : 'light';
    final js = '''
      (function() {
        try {
          localStorage.setItem('mh_opti_theme_mode', '$themeMode');
          localStorage.setItem('mh_opti_lang', '$langKey');
          window.location.reload();
        } catch (e) { console.error(e); }
      })();
    ''';
    _controller!.runJavaScript(js);
  }

  Future<void> _openOptimizerExternal() async {
    await launchUrl(_optimizerUri, mode: LaunchMode.externalApplication);
  }

  bool _supportsWebView() {
    if (kIsWeb) return false;
    final supportedPlatform = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
    return supportedPlatform && WebViewPlatform.instance != null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: _isWebViewSupported && _controller != null
              ? Stack(
                  children: [
                    WebViewWidget(controller: _controller!),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.open_in_browser,
                          size: 44,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.webViewNotSupported,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.openInBrowserHint,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _openOptimizerExternal,
                          icon: const Icon(Icons.launch),
                          label: Text(AppLocalizations.of(context)!.openOptimizer),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

Future<void> showBuildOptimizerCreditsDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  const githubUrl = 'https://github.com/Nenrikido/MH-Optimizer';
  const websiteUrl = 'https://mh-opti.nenri.fr/';

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final cs = Theme.of(dialogContext).colorScheme;
      final bodyStyle = TextStyle(
        color: cs.onSurface,
        fontSize: 16,
        height: 1.4,
      );
      return AlertDialog(
        backgroundColor: cs.surfaceContainerHighest,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.buildOptimizer,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.buildOptimizerCreditsIntro,
              style: bodyStyle,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.buildOptimizerCreditsCreator,
              style: bodyStyle.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilledButton(
                  onPressed: () {
                    launchUrl(
                      Uri.parse(websiteUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    minimumSize: const Size(40, 40),
                  ),
                  child: const Icon(Icons.language, size: 18),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    launchUrl(
                      Uri.parse(githubUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    minimumSize: const Size(40, 40),
                  ),
                  child: const FaIcon(FontAwesomeIcons.github, size: 18),
                ),
              ],
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppLocalizations.of(dialogContext)!.ok),
          ),
        ],
      );
    },
  );
}

