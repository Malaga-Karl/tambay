import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://tambay.co'));

    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: controller)),
      // body: Center(child: Text("May Internet")),
    );
  }
}
