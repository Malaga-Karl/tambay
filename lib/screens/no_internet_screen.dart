import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'wala kayong internet',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
    );
  }
}
