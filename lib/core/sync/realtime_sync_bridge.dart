import 'dart:async';
import 'package:logger/logger.dart';

typedef RealtimeEventHandler = Future<void> Function(
  String eventType,
  String table,
  Map<String, dynamic> record,
);

class RealtimeSyncBridge {
  final Map<String, RealtimeEventHandler> _handlers = {};
  final Set<String> _processedIdempotencyKeys = {};
  final Logger _logger;

  RealtimeSyncBridge({Logger? logger}) : _logger = logger ?? Logger();

  /// Registers a table-specific event handler.
  void registerHandler(String table, RealtimeEventHandler handler) {
    _handlers[table] = handler;
  }

  /// Records an acknowledged outbox idempotency key so incoming Realtime echo events are ignored.
  void recordAcknowledgedKey(String idempotencyKey) {
    _processedIdempotencyKeys.add(idempotencyKey);
    // Keep set bounded to prevent memory growth
    if (_processedIdempotencyKeys.length > 500) {
      _processedIdempotencyKeys.remove(_processedIdempotencyKeys.first);
    }
  }

  /// Dispatches incoming Realtime CDC payload to registered handlers with duplicate suppression.
  Future<bool> handleRealtimePayload(Map<String, dynamic> payload) async {
    final eventType = payload['eventType'] as String? ?? 'INSERT';
    final table = payload['table'] as String? ?? '';
    final record = payload['new'] as Map<String, dynamic>? ?? payload['record'] as Map<String, dynamic>? ?? {};

    final idempotencyKey = record['idempotency_key'] as String?;
    if (idempotencyKey != null && _processedIdempotencyKeys.contains(idempotencyKey)) {
      _logger.d('Ignored Realtime echo for idempotencyKey: $idempotencyKey');
      return false; // Suppressed echo
    }

    final handler = _handlers[table];
    if (handler != null) {
      await handler(eventType, table, record);
      return true;
    }

    return false;
  }
}
