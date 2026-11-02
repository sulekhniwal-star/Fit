import 'dart:convert';

enum OutboxStatus {
  pending,
  inFlight,
  failed,
  completed,
}

enum OutboxOperation {
  insert,
  update,
  delete,
}

class SyncMutation {
  final String id;
  final String entityType;
  final OutboxOperation operation;
  final Map<String, dynamic> payload;
  final String idempotencyKey;
  final DateTime createdAt;
  final int retryCount;
  final OutboxStatus status;
  final String? lastError;
  final String? dependencyId;

  const SyncMutation({
    required this.id,
    required this.entityType,
    required this.operation,
    required this.payload,
    required this.idempotencyKey,
    required this.createdAt,
    this.retryCount = 0,
    this.status = OutboxStatus.pending,
    this.lastError,
    this.dependencyId,
  });

  String get payloadJson => jsonEncode(payload);

  SyncMutation copyWith({
    String? id,
    String? entityType,
    OutboxOperation? operation,
    Map<String, dynamic>? payload,
    String? idempotencyKey,
    DateTime? createdAt,
    int? retryCount,
    OutboxStatus? status,
    String? lastError,
    String? dependencyId,
  }) {
    return SyncMutation(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      dependencyId: dependencyId ?? this.dependencyId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'entity_type': entityType,
        'operation': operation.name,
        'payload': payload,
        'idempotency_key': idempotencyKey,
        'created_at': createdAt.toIso8601String(),
        'retry_count': retryCount,
        'status': status.name,
        if (lastError != null) 'last_error': lastError,
        if (dependencyId != null) 'dependency_id': dependencyId,
      };

  factory SyncMutation.fromJson(Map<String, dynamic> json) {
    return SyncMutation(
      id: json['id'] as String,
      entityType: json['entity_type'] as String,
      operation: OutboxOperation.values.firstWhere(
        (o) => o.name == json['operation'],
        orElse: () => OutboxOperation.insert,
      ),
      payload: json['payload'] is String
          ? jsonDecode(json['payload'] as String) as Map<String, dynamic>
          : (json['payload'] as Map<String, dynamic>? ?? {}),
      idempotencyKey: json['idempotency_key'] as String,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      retryCount: json['retry_count'] as int? ?? 0,
      status: OutboxStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OutboxStatus.pending,
      ),
      lastError: json['last_error'] as String?,
      dependencyId: json['dependency_id'] as String?,
    );
  }
}
