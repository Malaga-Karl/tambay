import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tambay/screens/no_internet_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

class ConnectionChecker extends StatefulWidget {
  const ConnectionChecker({super.key});

  @override
  State<ConnectionChecker> createState() => _ConnectionCheckerState();
}

class _ConnectionCheckerState extends State<ConnectionChecker> {
  late final StreamSubscription<List<ConnectivityResult>> subscription;
  bool hasInternet = false;
  late final WebViewController _controller;
  bool pageReachable = false;

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App?'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://tambay.co'));

    _checkConnection();

    subscription = Connectivity().onConnectivityChanged.listen((results) {
      final connected = results.any(
        (result) => result != ConnectivityResult.none,
      );
      setState(() {
        hasInternet = connected;
      });

      if (connected) {
        _checkPageReachable(reload: !pageReachable);
      } else {
        setState(() {
          pageReachable = false;
        });
      }
    });
  }

  Future<void> _checkPageReachable({bool reload = false}) async {
    setState(() {
      pageReachable = false;
    });
    try {
      final response = await http.get(Uri.parse('https://tambay.co'));
      if (response.statusCode == 200) {
        setState(() {
          pageReachable = true;
        });
        if (reload) {
          _controller.loadRequest(Uri.parse('https://tambay.co'));
        }
      }
    } catch (_) {
      setState(() {
        pageReachable = false;
      });
    }
  }

  Future<void> _checkConnection() async {
    var results = await Connectivity().checkConnectivity();
    setState(() {
      hasInternet = results.any((result) => result != ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hasInternet) {
      return WillPopScope(
        onWillPop: () async {
          if (await _controller.canGoBack()) {
            // Go back inside WebView history
            _controller.goBack();
            return false; // don’t exit app
          } else {
            // Show exit confirmation if no history left
            final confirmExit = await _showExitConfirmationDialog(context);
            return confirmExit; // true = exit
          }
        },
        child: Scaffold(
          body: SafeArea(child: WebViewWidget(controller: _controller)),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }
}
