import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WhatsappWebViewScreen extends StatefulWidget {
  final String whatsappUrl;

  const WhatsappWebViewScreen({super.key, required this.whatsappUrl});

  @override
  State<WhatsappWebViewScreen> createState() => _WhatsappWebViewScreenState();
}

class _WhatsappWebViewScreenState extends State<WhatsappWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // Allow navigation to the WhatsApp URL
            if (request.url.startsWith('https://wa.me/')) {
              return NavigationDecision.navigate;
            }
            // Block other navigations if not intended
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.whatsappUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abrir WhatsApp'),
        backgroundColor: const Color(0xFFFF6600),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}