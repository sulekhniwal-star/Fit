import 'package:fitkarma/core/localization/app_language.dart';
import 'package:fitkarma/core/localization/app_strings.dart';
import 'package:fitkarma/core/providers/app_providers.dart';
import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/shared/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root Application Widget for FitKarma with declarative GoRouter navigation,
/// dynamic locale switching, and dark design system.
class FitKarmaApp extends ConsumerWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final activeLocale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      locale: activeLocale,
      supportedLocales: AppLanguage.supportedLocales,
      localizationsDelegates: const [
        AppStrings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
