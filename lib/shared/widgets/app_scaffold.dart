import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'offline_banner.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool isOffline;
  final String? offlineMessage;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.isOffline = false,
    this.offlineMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Column(
          children: [
            if (isOffline)
              OfflineBanner(
                message: offlineMessage ?? 'Offline mode active — changes will sync automatically',
              ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

