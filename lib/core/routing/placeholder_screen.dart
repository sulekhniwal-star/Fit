import 'package:fitkarma/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// Lightweight placeholder screen for unbuilt modular routes.
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppConstants.primaryDarkBackgroundHex),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.dashboard_customize_outlined,
              size: 48,
              color: Colors.white70,
            ),
            const SizedBox(height: 12.0),
            Text(
              'Route: $title',
              style: const TextStyle(fontSize: 16, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
