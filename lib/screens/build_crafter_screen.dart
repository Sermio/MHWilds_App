import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Pantalla embebida para [MH Wilds Build Crafter](https://mhwilds-build-crafter.vercel.app/builder).
/// Misma idea que [BuildOptimizerScreen], sin inyectar localStorage de mh-opti.
class BuildCrafterScreen extends StatefulWidget {
  const BuildCrafterScreen({super.key});

  @override
  State<BuildCrafterScreen> createState() => _BuildCrafterScreenState();
}

class _BuildCrafterScreenState extends State<BuildCrafterScreen> {
  static final Uri _crafterUri =
      Uri.parse('https://mhwilds-build-crafter.vercel.app/builder');

  late final bool _isWebViewSupported;
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isWebViewSupported = _supportsWebView();
    if (_isWebViewSupported) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              if (!mounted) return;
              setState(() => _isLoading = true);
            },
            onPageFinished: (_) {
              if (!mounted) return;
              setState(() => _isLoading = false);
            },
          ),
        )
        ..loadRequest(_crafterUri);
    } else {
      _isLoading = false;
    }
  }

  Future<void> _openCrafterExternal() async {
    await launchUrl(_crafterUri, mode: LaunchMode.externalApplication);
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
    final l10n = AppLocalizations.of(context)!;

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
                          l10n.buildCrafterWebViewUnavailable,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _openCrafterExternal,
                          icon: const Icon(Icons.launch),
                          label: Text(l10n.buildCrafterOpenInBrowser),
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

Future<void> showBuildCrafterCreditsDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  const websiteUrl = 'https://mhwilds-build-crafter.vercel.app/builder';
  const githubUrl = 'https://github.com/Caydonst/mhwilds-build-crafter';

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
          l10n.buildCrafter,
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
              l10n.buildCrafterCreditsIntro,
              style: bodyStyle,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.buildCrafterCreditsCreator,
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
            child: Text(l10n.understood),
          ),
        ],
      );
    },
  );
}
