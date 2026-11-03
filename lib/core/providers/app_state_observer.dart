import 'package:fitkarma/core/services/logging_service_contract.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application-level Riverpod ProviderObserver for structured logging of lifecycle events.
class AppProviderObserver extends ProviderObserver {
  final LoggingServiceContract? logger;

  const AppProviderObserver({this.logger});

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    logger?.debug('Provider added: ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logger?.debug('Provider updated: ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    logger?.debug(
      'Provider disposed: ${provider.name ?? provider.runtimeType}',
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    logger?.error(
      'Provider failed: ${provider.name ?? provider.runtimeType}',
      error,
      stackTrace,
    );
  }
}
