
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MercadoPagoWebViewScreen extends StatefulWidget {
  final String initialUrl;

  const MercadoPagoWebViewScreen({Key? key, required this.initialUrl}) : super(key: key);

  @override
  State<MercadoPagoWebViewScreen> createState() => _MercadoPagoWebViewScreenState();
}

class _MercadoPagoWebViewScreenState extends State<MercadoPagoWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Você pode interceptar navegações aqui se precisar.
            // Por exemplo, para redirecionar de volta ao app em caso de sucesso/falha.
            if (request.url.startsWith('https://seusite.com/success')) {
              print('Pagamento aprovado!');
              Navigator.of(context).pop(); // Volta para a tela anterior
              // TODO: Limpar o carrinho, mostrar uma tela de sucesso, etc.
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finalizar Pagamento"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
