// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OutboxMutationsTable extends OutboxMutations
    with TableInfo<$OutboxMutationsTable, OutboxMutation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxMutationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dependencyIdMeta = const VerificationMeta(
    'dependencyId',
  );
  @override
  late final GeneratedColumn<String> dependencyId = GeneratedColumn<String>(
    'dependency_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    operationType,
    payloadJson,
    idempotencyKey,
    createdAt,
    retryCount,
    status,
    lastError,
    dependencyId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_mutations';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxMutation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('dependency_id')) {
      context.handle(
        _dependencyIdMeta,
        dependencyId.isAcceptableOrUnknown(
          data['dependency_id']!,
          _dependencyIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxMutation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxMutation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      dependencyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dependency_id'],
      ),
    );
  }

  @override
  $OutboxMutationsTable createAlias(String alias) {
    return $OutboxMutationsTable(attachedDatabase, alias);
  }
}

class OutboxMutation extends DataClass implements Insertable<OutboxMutation> {
  final String id;
  final String entityType;
  final String operationType;
  final String payloadJson;
  final String idempotencyKey;
  final DateTime createdAt;
  final int retryCount;
  final String status;
  final String? lastError;
  final String? dependencyId;
  const OutboxMutation({
    required this.id,
    required this.entityType,
    required this.operationType,
    required this.payloadJson,
    required this.idempotencyKey,
    required this.createdAt,
    required this.retryCount,
    required this.status,
    this.lastError,
    this.dependencyId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['operation_type'] = Variable<String>(operationType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || dependencyId != null) {
      map['dependency_id'] = Variable<String>(dependencyId);
    }
    return map;
  }

  OutboxMutationsCompanion toCompanion(bool nullToAbsent) {
    return OutboxMutationsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      operationType: Value(operationType),
      payloadJson: Value(payloadJson),
      idempotencyKey: Value(idempotencyKey),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      status: Value(status),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      dependencyId: dependencyId == null && nullToAbsent
          ? const Value.absent()
          : Value(dependencyId),
    );
  }

  factory OutboxMutation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxMutation(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      operationType: serializer.fromJson<String>(json['operationType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      status: serializer.fromJson<String>(json['status']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      dependencyId: serializer.fromJson<String?>(json['dependencyId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'operationType': serializer.toJson<String>(operationType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'status': serializer.toJson<String>(status),
      'lastError': serializer.toJson<String?>(lastError),
      'dependencyId': serializer.toJson<String?>(dependencyId),
    };
  }

  OutboxMutation copyWith({
    String? id,
    String? entityType,
    String? operationType,
    String? payloadJson,
    String? idempotencyKey,
    DateTime? createdAt,
    int? retryCount,
    String? status,
    Value<String?> lastError = const Value.absent(),
    Value<String?> dependencyId = const Value.absent(),
  }) => OutboxMutation(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    operationType: operationType ?? this.operationType,
    payloadJson: payloadJson ?? this.payloadJson,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
    status: status ?? this.status,
    lastError: lastError.present ? lastError.value : this.lastError,
    dependencyId: dependencyId.present ? dependencyId.value : this.dependencyId,
  );
  OutboxMutation copyWithCompanion(OutboxMutationsCompanion data) {
    return OutboxMutation(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      status: data.status.present ? data.status.value : this.status,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      dependencyId: data.dependencyId.present
          ? data.dependencyId.value
          : this.dependencyId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxMutation(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('dependencyId: $dependencyId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    operationType,
    payloadJson,
    idempotencyKey,
    createdAt,
    retryCount,
    status,
    lastError,
    dependencyId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxMutation &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.operationType == this.operationType &&
          other.payloadJson == this.payloadJson &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.status == this.status &&
          other.lastError == this.lastError &&
          other.dependencyId == this.dependencyId);
}

class OutboxMutationsCompanion extends UpdateCompanion<OutboxMutation> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> operationType;
  final Value<String> payloadJson;
  final Value<String> idempotencyKey;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String> status;
  final Value<String?> lastError;
  final Value<String?> dependencyId;
  final Value<int> rowid;
  const OutboxMutationsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.operationType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.dependencyId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxMutationsCompanion.insert({
    required String id,
    required String entityType,
    required String operationType,
    required String payloadJson,
    required String idempotencyKey,
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.dependencyId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       operationType = Value(operationType),
       payloadJson = Value(payloadJson),
       idempotencyKey = Value(idempotencyKey),
       createdAt = Value(createdAt);
  static Insertable<OutboxMutation> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? operationType,
    Expression<String>? payloadJson,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? status,
    Expression<String>? lastError,
    Expression<String>? dependencyId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (operationType != null) 'operation_type': operationType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (status != null) 'status': status,
      if (lastError != null) 'last_error': lastError,
      if (dependencyId != null) 'dependency_id': dependencyId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxMutationsCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? operationType,
    Value<String>? payloadJson,
    Value<String>? idempotencyKey,
    Value<DateTime>? createdAt,
    Value<int>? retryCount,
    Value<String>? status,
    Value<String?>? lastError,
    Value<String?>? dependencyId,
    Value<int>? rowid,
  }) {
    return OutboxMutationsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      operationType: operationType ?? this.operationType,
      payloadJson: payloadJson ?? this.payloadJson,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      dependencyId: dependencyId ?? this.dependencyId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (dependencyId.present) {
      map['dependency_id'] = Variable<String>(dependencyId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxMutationsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('dependencyId: $dependencyId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUserProfilesTable extends LocalUserProfiles
    with TableInfo<$LocalUserProfilesTable, LocalUserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _biologicalSexMeta = const VerificationMeta(
    'biologicalSex',
  );
  @override
  late final GeneratedColumn<String> biologicalSex = GeneratedColumn<String>(
    'biological_sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dietaryIdentityMeta = const VerificationMeta(
    'dietaryIdentity',
  );
  @override
  late final GeneratedColumn<String> dietaryIdentity = GeneratedColumn<String>(
    'dietary_identity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _healthGoalMeta = const VerificationMeta(
    'healthGoal',
  );
  @override
  late final GeneratedColumn<String> healthGoal = GeneratedColumn<String>(
    'health_goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _doshaProfileJsonMeta = const VerificationMeta(
    'doshaProfileJson',
  );
  @override
  late final GeneratedColumn<String> doshaProfileJson = GeneratedColumn<String>(
    'dosha_profile_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasAcceptedDpdpConsentMeta =
      const VerificationMeta('hasAcceptedDpdpConsent');
  @override
  late final GeneratedColumn<bool> hasAcceptedDpdpConsent =
      GeneratedColumn<bool>(
        'has_accepted_dpdp_consent',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_accepted_dpdp_consent" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    displayName,
    age,
    biologicalSex,
    heightCm,
    weightKg,
    targetWeightKg,
    activityLevel,
    dietaryIdentity,
    healthGoal,
    languageCode,
    doshaProfileJson,
    hasAcceptedDpdpConsent,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('biological_sex')) {
      context.handle(
        _biologicalSexMeta,
        biologicalSex.isAcceptableOrUnknown(
          data['biological_sex']!,
          _biologicalSexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_biologicalSexMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityLevelMeta);
    }
    if (data.containsKey('dietary_identity')) {
      context.handle(
        _dietaryIdentityMeta,
        dietaryIdentity.isAcceptableOrUnknown(
          data['dietary_identity']!,
          _dietaryIdentityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dietaryIdentityMeta);
    }
    if (data.containsKey('health_goal')) {
      context.handle(
        _healthGoalMeta,
        healthGoal.isAcceptableOrUnknown(data['health_goal']!, _healthGoalMeta),
      );
    } else if (isInserting) {
      context.missing(_healthGoalMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    }
    if (data.containsKey('dosha_profile_json')) {
      context.handle(
        _doshaProfileJsonMeta,
        doshaProfileJson.isAcceptableOrUnknown(
          data['dosha_profile_json']!,
          _doshaProfileJsonMeta,
        ),
      );
    }
    if (data.containsKey('has_accepted_dpdp_consent')) {
      context.handle(
        _hasAcceptedDpdpConsentMeta,
        hasAcceptedDpdpConsent.isAcceptableOrUnknown(
          data['has_accepted_dpdp_consent']!,
          _hasAcceptedDpdpConsentMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  LocalUserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserProfile(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      biologicalSex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}biological_sex'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      ),
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      )!,
      dietaryIdentity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dietary_identity'],
      )!,
      healthGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}health_goal'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      doshaProfileJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosha_profile_json'],
      ),
      hasAcceptedDpdpConsent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_accepted_dpdp_consent'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalUserProfilesTable createAlias(String alias) {
    return $LocalUserProfilesTable(attachedDatabase, alias);
  }
}

class LocalUserProfile extends DataClass
    implements Insertable<LocalUserProfile> {
  final String userId;
  final String displayName;
  final int age;
  final String biologicalSex;
  final double heightCm;
  final double weightKg;
  final double? targetWeightKg;
  final String activityLevel;
  final String dietaryIdentity;
  final String healthGoal;
  final String languageCode;
  final String? doshaProfileJson;
  final bool hasAcceptedDpdpConsent;
  final DateTime updatedAt;
  const LocalUserProfile({
    required this.userId,
    required this.displayName,
    required this.age,
    required this.biologicalSex,
    required this.heightCm,
    required this.weightKg,
    this.targetWeightKg,
    required this.activityLevel,
    required this.dietaryIdentity,
    required this.healthGoal,
    required this.languageCode,
    this.doshaProfileJson,
    required this.hasAcceptedDpdpConsent,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['display_name'] = Variable<String>(displayName);
    map['age'] = Variable<int>(age);
    map['biological_sex'] = Variable<String>(biologicalSex);
    map['height_cm'] = Variable<double>(heightCm);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || targetWeightKg != null) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg);
    }
    map['activity_level'] = Variable<String>(activityLevel);
    map['dietary_identity'] = Variable<String>(dietaryIdentity);
    map['health_goal'] = Variable<String>(healthGoal);
    map['language_code'] = Variable<String>(languageCode);
    if (!nullToAbsent || doshaProfileJson != null) {
      map['dosha_profile_json'] = Variable<String>(doshaProfileJson);
    }
    map['has_accepted_dpdp_consent'] = Variable<bool>(hasAcceptedDpdpConsent);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalUserProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalUserProfilesCompanion(
      userId: Value(userId),
      displayName: Value(displayName),
      age: Value(age),
      biologicalSex: Value(biologicalSex),
      heightCm: Value(heightCm),
      weightKg: Value(weightKg),
      targetWeightKg: targetWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeightKg),
      activityLevel: Value(activityLevel),
      dietaryIdentity: Value(dietaryIdentity),
      healthGoal: Value(healthGoal),
      languageCode: Value(languageCode),
      doshaProfileJson: doshaProfileJson == null && nullToAbsent
          ? const Value.absent()
          : Value(doshaProfileJson),
      hasAcceptedDpdpConsent: Value(hasAcceptedDpdpConsent),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalUserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserProfile(
      userId: serializer.fromJson<String>(json['userId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      age: serializer.fromJson<int>(json['age']),
      biologicalSex: serializer.fromJson<String>(json['biologicalSex']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      targetWeightKg: serializer.fromJson<double?>(json['targetWeightKg']),
      activityLevel: serializer.fromJson<String>(json['activityLevel']),
      dietaryIdentity: serializer.fromJson<String>(json['dietaryIdentity']),
      healthGoal: serializer.fromJson<String>(json['healthGoal']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      doshaProfileJson: serializer.fromJson<String?>(json['doshaProfileJson']),
      hasAcceptedDpdpConsent: serializer.fromJson<bool>(
        json['hasAcceptedDpdpConsent'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'displayName': serializer.toJson<String>(displayName),
      'age': serializer.toJson<int>(age),
      'biologicalSex': serializer.toJson<String>(biologicalSex),
      'heightCm': serializer.toJson<double>(heightCm),
      'weightKg': serializer.toJson<double>(weightKg),
      'targetWeightKg': serializer.toJson<double?>(targetWeightKg),
      'activityLevel': serializer.toJson<String>(activityLevel),
      'dietaryIdentity': serializer.toJson<String>(dietaryIdentity),
      'healthGoal': serializer.toJson<String>(healthGoal),
      'languageCode': serializer.toJson<String>(languageCode),
      'doshaProfileJson': serializer.toJson<String?>(doshaProfileJson),
      'hasAcceptedDpdpConsent': serializer.toJson<bool>(hasAcceptedDpdpConsent),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalUserProfile copyWith({
    String? userId,
    String? displayName,
    int? age,
    String? biologicalSex,
    double? heightCm,
    double? weightKg,
    Value<double?> targetWeightKg = const Value.absent(),
    String? activityLevel,
    String? dietaryIdentity,
    String? healthGoal,
    String? languageCode,
    Value<String?> doshaProfileJson = const Value.absent(),
    bool? hasAcceptedDpdpConsent,
    DateTime? updatedAt,
  }) => LocalUserProfile(
    userId: userId ?? this.userId,
    displayName: displayName ?? this.displayName,
    age: age ?? this.age,
    biologicalSex: biologicalSex ?? this.biologicalSex,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    targetWeightKg: targetWeightKg.present
        ? targetWeightKg.value
        : this.targetWeightKg,
    activityLevel: activityLevel ?? this.activityLevel,
    dietaryIdentity: dietaryIdentity ?? this.dietaryIdentity,
    healthGoal: healthGoal ?? this.healthGoal,
    languageCode: languageCode ?? this.languageCode,
    doshaProfileJson: doshaProfileJson.present
        ? doshaProfileJson.value
        : this.doshaProfileJson,
    hasAcceptedDpdpConsent:
        hasAcceptedDpdpConsent ?? this.hasAcceptedDpdpConsent,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalUserProfile copyWithCompanion(LocalUserProfilesCompanion data) {
    return LocalUserProfile(
      userId: data.userId.present ? data.userId.value : this.userId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      age: data.age.present ? data.age.value : this.age,
      biologicalSex: data.biologicalSex.present
          ? data.biologicalSex.value
          : this.biologicalSex,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      dietaryIdentity: data.dietaryIdentity.present
          ? data.dietaryIdentity.value
          : this.dietaryIdentity,
      healthGoal: data.healthGoal.present
          ? data.healthGoal.value
          : this.healthGoal,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      doshaProfileJson: data.doshaProfileJson.present
          ? data.doshaProfileJson.value
          : this.doshaProfileJson,
      hasAcceptedDpdpConsent: data.hasAcceptedDpdpConsent.present
          ? data.hasAcceptedDpdpConsent.value
          : this.hasAcceptedDpdpConsent,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserProfile(')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('age: $age, ')
          ..write('biologicalSex: $biologicalSex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('dietaryIdentity: $dietaryIdentity, ')
          ..write('healthGoal: $healthGoal, ')
          ..write('languageCode: $languageCode, ')
          ..write('doshaProfileJson: $doshaProfileJson, ')
          ..write('hasAcceptedDpdpConsent: $hasAcceptedDpdpConsent, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    displayName,
    age,
    biologicalSex,
    heightCm,
    weightKg,
    targetWeightKg,
    activityLevel,
    dietaryIdentity,
    healthGoal,
    languageCode,
    doshaProfileJson,
    hasAcceptedDpdpConsent,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserProfile &&
          other.userId == this.userId &&
          other.displayName == this.displayName &&
          other.age == this.age &&
          other.biologicalSex == this.biologicalSex &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.targetWeightKg == this.targetWeightKg &&
          other.activityLevel == this.activityLevel &&
          other.dietaryIdentity == this.dietaryIdentity &&
          other.healthGoal == this.healthGoal &&
          other.languageCode == this.languageCode &&
          other.doshaProfileJson == this.doshaProfileJson &&
          other.hasAcceptedDpdpConsent == this.hasAcceptedDpdpConsent &&
          other.updatedAt == this.updatedAt);
}

class LocalUserProfilesCompanion extends UpdateCompanion<LocalUserProfile> {
  final Value<String> userId;
  final Value<String> displayName;
  final Value<int> age;
  final Value<String> biologicalSex;
  final Value<double> heightCm;
  final Value<double> weightKg;
  final Value<double?> targetWeightKg;
  final Value<String> activityLevel;
  final Value<String> dietaryIdentity;
  final Value<String> healthGoal;
  final Value<String> languageCode;
  final Value<String?> doshaProfileJson;
  final Value<bool> hasAcceptedDpdpConsent;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalUserProfilesCompanion({
    this.userId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.age = const Value.absent(),
    this.biologicalSex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.dietaryIdentity = const Value.absent(),
    this.healthGoal = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.doshaProfileJson = const Value.absent(),
    this.hasAcceptedDpdpConsent = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserProfilesCompanion.insert({
    required String userId,
    required String displayName,
    required int age,
    required String biologicalSex,
    required double heightCm,
    required double weightKg,
    this.targetWeightKg = const Value.absent(),
    required String activityLevel,
    required String dietaryIdentity,
    required String healthGoal,
    this.languageCode = const Value.absent(),
    this.doshaProfileJson = const Value.absent(),
    this.hasAcceptedDpdpConsent = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       displayName = Value(displayName),
       age = Value(age),
       biologicalSex = Value(biologicalSex),
       heightCm = Value(heightCm),
       weightKg = Value(weightKg),
       activityLevel = Value(activityLevel),
       dietaryIdentity = Value(dietaryIdentity),
       healthGoal = Value(healthGoal),
       updatedAt = Value(updatedAt);
  static Insertable<LocalUserProfile> custom({
    Expression<String>? userId,
    Expression<String>? displayName,
    Expression<int>? age,
    Expression<String>? biologicalSex,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<double>? targetWeightKg,
    Expression<String>? activityLevel,
    Expression<String>? dietaryIdentity,
    Expression<String>? healthGoal,
    Expression<String>? languageCode,
    Expression<String>? doshaProfileJson,
    Expression<bool>? hasAcceptedDpdpConsent,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (displayName != null) 'display_name': displayName,
      if (age != null) 'age': age,
      if (biologicalSex != null) 'biological_sex': biologicalSex,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (dietaryIdentity != null) 'dietary_identity': dietaryIdentity,
      if (healthGoal != null) 'health_goal': healthGoal,
      if (languageCode != null) 'language_code': languageCode,
      if (doshaProfileJson != null) 'dosha_profile_json': doshaProfileJson,
      if (hasAcceptedDpdpConsent != null)
        'has_accepted_dpdp_consent': hasAcceptedDpdpConsent,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserProfilesCompanion copyWith({
    Value<String>? userId,
    Value<String>? displayName,
    Value<int>? age,
    Value<String>? biologicalSex,
    Value<double>? heightCm,
    Value<double>? weightKg,
    Value<double?>? targetWeightKg,
    Value<String>? activityLevel,
    Value<String>? dietaryIdentity,
    Value<String>? healthGoal,
    Value<String>? languageCode,
    Value<String?>? doshaProfileJson,
    Value<bool>? hasAcceptedDpdpConsent,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalUserProfilesCompanion(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      dietaryIdentity: dietaryIdentity ?? this.dietaryIdentity,
      healthGoal: healthGoal ?? this.healthGoal,
      languageCode: languageCode ?? this.languageCode,
      doshaProfileJson: doshaProfileJson ?? this.doshaProfileJson,
      hasAcceptedDpdpConsent:
          hasAcceptedDpdpConsent ?? this.hasAcceptedDpdpConsent,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (biologicalSex.present) {
      map['biological_sex'] = Variable<String>(biologicalSex.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (dietaryIdentity.present) {
      map['dietary_identity'] = Variable<String>(dietaryIdentity.value);
    }
    if (healthGoal.present) {
      map['health_goal'] = Variable<String>(healthGoal.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (doshaProfileJson.present) {
      map['dosha_profile_json'] = Variable<String>(doshaProfileJson.value);
    }
    if (hasAcceptedDpdpConsent.present) {
      map['has_accepted_dpdp_consent'] = Variable<bool>(
        hasAcceptedDpdpConsent.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserProfilesCompanion(')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('age: $age, ')
          ..write('biologicalSex: $biologicalSex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('dietaryIdentity: $dietaryIdentity, ')
          ..write('healthGoal: $healthGoal, ')
          ..write('languageCode: $languageCode, ')
          ..write('doshaProfileJson: $doshaProfileJson, ')
          ..write('hasAcceptedDpdpConsent: $hasAcceptedDpdpConsent, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyMetricEntriesTableTable extends BodyMetricEntriesTable
    with TableInfo<$BodyMetricEntriesTableTable, BodyMetricEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyMetricEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metricTypeMeta = const VerificationMeta(
    'metricType',
  );
  @override
  late final GeneratedColumn<String> metricType = GeneratedColumn<String>(
    'metric_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    metricType,
    value,
    unit,
    recordedAt,
    source,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_metric_entries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyMetricEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('metric_type')) {
      context.handle(
        _metricTypeMeta,
        metricType.isAcceptableOrUnknown(data['metric_type']!, _metricTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_metricTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyMetricEntriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyMetricEntriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      metricType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric_type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $BodyMetricEntriesTableTable createAlias(String alias) {
    return $BodyMetricEntriesTableTable(attachedDatabase, alias);
  }
}

class BodyMetricEntriesTableData extends DataClass
    implements Insertable<BodyMetricEntriesTableData> {
  final String id;
  final String userId;
  final String metricType;
  final double value;
  final String unit;
  final DateTime recordedAt;
  final String source;
  final String? notes;
  const BodyMetricEntriesTableData({
    required this.id,
    required this.userId,
    required this.metricType,
    required this.value,
    required this.unit,
    required this.recordedAt,
    required this.source,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['metric_type'] = Variable<String>(metricType);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  BodyMetricEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return BodyMetricEntriesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      metricType: Value(metricType),
      value: Value(value),
      unit: Value(unit),
      recordedAt: Value(recordedAt),
      source: Value(source),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory BodyMetricEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyMetricEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      metricType: serializer.fromJson<String>(json['metricType']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      source: serializer.fromJson<String>(json['source']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'metricType': serializer.toJson<String>(metricType),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  BodyMetricEntriesTableData copyWith({
    String? id,
    String? userId,
    String? metricType,
    double? value,
    String? unit,
    DateTime? recordedAt,
    String? source,
    Value<String?> notes = const Value.absent(),
  }) => BodyMetricEntriesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    metricType: metricType ?? this.metricType,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    recordedAt: recordedAt ?? this.recordedAt,
    source: source ?? this.source,
    notes: notes.present ? notes.value : this.notes,
  );
  BodyMetricEntriesTableData copyWithCompanion(
    BodyMetricEntriesTableCompanion data,
  ) {
    return BodyMetricEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      metricType: data.metricType.present
          ? data.metricType.value
          : this.metricType,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyMetricEntriesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('metricType: $metricType, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('source: $source, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    metricType,
    value,
    unit,
    recordedAt,
    source,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyMetricEntriesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.metricType == this.metricType &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.recordedAt == this.recordedAt &&
          other.source == this.source &&
          other.notes == this.notes);
}

class BodyMetricEntriesTableCompanion
    extends UpdateCompanion<BodyMetricEntriesTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> metricType;
  final Value<double> value;
  final Value<String> unit;
  final Value<DateTime> recordedAt;
  final Value<String> source;
  final Value<String?> notes;
  final Value<int> rowid;
  const BodyMetricEntriesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.metricType = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodyMetricEntriesTableCompanion.insert({
    required String id,
    required String userId,
    required String metricType,
    required double value,
    required String unit,
    required DateTime recordedAt,
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       metricType = Value(metricType),
       value = Value(value),
       unit = Value(unit),
       recordedAt = Value(recordedAt);
  static Insertable<BodyMetricEntriesTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? metricType,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<DateTime>? recordedAt,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (metricType != null) 'metric_type': metricType,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodyMetricEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? metricType,
    Value<double>? value,
    Value<String>? unit,
    Value<DateTime>? recordedAt,
    Value<String>? source,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return BodyMetricEntriesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      metricType: metricType ?? this.metricType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      recordedAt: recordedAt ?? this.recordedAt,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (metricType.present) {
      map['metric_type'] = Variable<String>(metricType.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyMetricEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('metricType: $metricType, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StepRecordsTableTable extends StepRecordsTable
    with TableInfo<$StepRecordsTableTable, StepRecordsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StepRecordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepCountMeta = const VerificationMeta(
    'stepCount',
  );
  @override
  late final GeneratedColumn<int> stepCount = GeneratedColumn<int>(
    'step_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<int> goal = GeneratedColumn<int>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10000),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    date,
    stepCount,
    goal,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'step_records_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StepRecordsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('step_count')) {
      context.handle(
        _stepCountMeta,
        stepCount.isAcceptableOrUnknown(data['step_count']!, _stepCountMeta),
      );
    } else if (isInserting) {
      context.missing(_stepCountMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StepRecordsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StepRecordsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      stepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_count'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $StepRecordsTableTable createAlias(String alias) {
    return $StepRecordsTableTable(attachedDatabase, alias);
  }
}

class StepRecordsTableData extends DataClass
    implements Insertable<StepRecordsTableData> {
  final String id;
  final String userId;
  final DateTime date;
  final int stepCount;
  final int goal;
  final String source;
  const StepRecordsTableData({
    required this.id,
    required this.userId,
    required this.date,
    required this.stepCount,
    required this.goal,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<DateTime>(date);
    map['step_count'] = Variable<int>(stepCount);
    map['goal'] = Variable<int>(goal);
    map['source'] = Variable<String>(source);
    return map;
  }

  StepRecordsTableCompanion toCompanion(bool nullToAbsent) {
    return StepRecordsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      date: Value(date),
      stepCount: Value(stepCount),
      goal: Value(goal),
      source: Value(source),
    );
  }

  factory StepRecordsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StepRecordsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<DateTime>(json['date']),
      stepCount: serializer.fromJson<int>(json['stepCount']),
      goal: serializer.fromJson<int>(json['goal']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<DateTime>(date),
      'stepCount': serializer.toJson<int>(stepCount),
      'goal': serializer.toJson<int>(goal),
      'source': serializer.toJson<String>(source),
    };
  }

  StepRecordsTableData copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? stepCount,
    int? goal,
    String? source,
  }) => StepRecordsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    date: date ?? this.date,
    stepCount: stepCount ?? this.stepCount,
    goal: goal ?? this.goal,
    source: source ?? this.source,
  );
  StepRecordsTableData copyWithCompanion(StepRecordsTableCompanion data) {
    return StepRecordsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      stepCount: data.stepCount.present ? data.stepCount.value : this.stepCount,
      goal: data.goal.present ? data.goal.value : this.goal,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StepRecordsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('stepCount: $stepCount, ')
          ..write('goal: $goal, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, date, stepCount, goal, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StepRecordsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.stepCount == this.stepCount &&
          other.goal == this.goal &&
          other.source == this.source);
}

class StepRecordsTableCompanion extends UpdateCompanion<StepRecordsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> date;
  final Value<int> stepCount;
  final Value<int> goal;
  final Value<String> source;
  final Value<int> rowid;
  const StepRecordsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.stepCount = const Value.absent(),
    this.goal = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StepRecordsTableCompanion.insert({
    required String id,
    required String userId,
    required DateTime date,
    required int stepCount,
    this.goal = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       date = Value(date),
       stepCount = Value(stepCount);
  static Insertable<StepRecordsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? date,
    Expression<int>? stepCount,
    Expression<int>? goal,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (stepCount != null) 'step_count': stepCount,
      if (goal != null) 'goal': goal,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StepRecordsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? date,
    Value<int>? stepCount,
    Value<int>? goal,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return StepRecordsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      stepCount: stepCount ?? this.stepCount,
      goal: goal ?? this.goal,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (stepCount.present) {
      map['step_count'] = Variable<int>(stepCount.value);
    }
    if (goal.present) {
      map['goal'] = Variable<int>(goal.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StepRecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('stepCount: $stepCount, ')
          ..write('goal: $goal, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SleepRecordsTableTable extends SleepRecordsTable
    with TableInfo<$SleepRecordsTableTable, SleepRecordsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepRecordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityRatingMeta = const VerificationMeta(
    'qualityRating',
  );
  @override
  late final GeneratedColumn<int> qualityRating = GeneratedColumn<int>(
    'quality_rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _deepSleepMinutesMeta = const VerificationMeta(
    'deepSleepMinutes',
  );
  @override
  late final GeneratedColumn<int> deepSleepMinutes = GeneratedColumn<int>(
    'deep_sleep_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remSleepMinutesMeta = const VerificationMeta(
    'remSleepMinutes',
  );
  @override
  late final GeneratedColumn<int> remSleepMinutes = GeneratedColumn<int>(
    'rem_sleep_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    startTime,
    endTime,
    durationMinutes,
    qualityRating,
    deepSleepMinutes,
    remSleepMinutes,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_records_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepRecordsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('quality_rating')) {
      context.handle(
        _qualityRatingMeta,
        qualityRating.isAcceptableOrUnknown(
          data['quality_rating']!,
          _qualityRatingMeta,
        ),
      );
    }
    if (data.containsKey('deep_sleep_minutes')) {
      context.handle(
        _deepSleepMinutesMeta,
        deepSleepMinutes.isAcceptableOrUnknown(
          data['deep_sleep_minutes']!,
          _deepSleepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('rem_sleep_minutes')) {
      context.handle(
        _remSleepMinutesMeta,
        remSleepMinutes.isAcceptableOrUnknown(
          data['rem_sleep_minutes']!,
          _remSleepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepRecordsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepRecordsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      qualityRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality_rating'],
      )!,
      deepSleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deep_sleep_minutes'],
      ),
      remSleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rem_sleep_minutes'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $SleepRecordsTableTable createAlias(String alias) {
    return $SleepRecordsTableTable(attachedDatabase, alias);
  }
}

class SleepRecordsTableData extends DataClass
    implements Insertable<SleepRecordsTableData> {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final int qualityRating;
  final int? deepSleepMinutes;
  final int? remSleepMinutes;
  final String source;
  const SleepRecordsTableData({
    required this.id,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.qualityRating,
    this.deepSleepMinutes,
    this.remSleepMinutes,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['quality_rating'] = Variable<int>(qualityRating);
    if (!nullToAbsent || deepSleepMinutes != null) {
      map['deep_sleep_minutes'] = Variable<int>(deepSleepMinutes);
    }
    if (!nullToAbsent || remSleepMinutes != null) {
      map['rem_sleep_minutes'] = Variable<int>(remSleepMinutes);
    }
    map['source'] = Variable<String>(source);
    return map;
  }

  SleepRecordsTableCompanion toCompanion(bool nullToAbsent) {
    return SleepRecordsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      durationMinutes: Value(durationMinutes),
      qualityRating: Value(qualityRating),
      deepSleepMinutes: deepSleepMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(deepSleepMinutes),
      remSleepMinutes: remSleepMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(remSleepMinutes),
      source: Value(source),
    );
  }

  factory SleepRecordsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepRecordsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      qualityRating: serializer.fromJson<int>(json['qualityRating']),
      deepSleepMinutes: serializer.fromJson<int?>(json['deepSleepMinutes']),
      remSleepMinutes: serializer.fromJson<int?>(json['remSleepMinutes']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'qualityRating': serializer.toJson<int>(qualityRating),
      'deepSleepMinutes': serializer.toJson<int?>(deepSleepMinutes),
      'remSleepMinutes': serializer.toJson<int?>(remSleepMinutes),
      'source': serializer.toJson<String>(source),
    };
  }

  SleepRecordsTableData copyWith({
    String? id,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    int? qualityRating,
    Value<int?> deepSleepMinutes = const Value.absent(),
    Value<int?> remSleepMinutes = const Value.absent(),
    String? source,
  }) => SleepRecordsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    qualityRating: qualityRating ?? this.qualityRating,
    deepSleepMinutes: deepSleepMinutes.present
        ? deepSleepMinutes.value
        : this.deepSleepMinutes,
    remSleepMinutes: remSleepMinutes.present
        ? remSleepMinutes.value
        : this.remSleepMinutes,
    source: source ?? this.source,
  );
  SleepRecordsTableData copyWithCompanion(SleepRecordsTableCompanion data) {
    return SleepRecordsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      qualityRating: data.qualityRating.present
          ? data.qualityRating.value
          : this.qualityRating,
      deepSleepMinutes: data.deepSleepMinutes.present
          ? data.deepSleepMinutes.value
          : this.deepSleepMinutes,
      remSleepMinutes: data.remSleepMinutes.present
          ? data.remSleepMinutes.value
          : this.remSleepMinutes,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepRecordsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('qualityRating: $qualityRating, ')
          ..write('deepSleepMinutes: $deepSleepMinutes, ')
          ..write('remSleepMinutes: $remSleepMinutes, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    startTime,
    endTime,
    durationMinutes,
    qualityRating,
    deepSleepMinutes,
    remSleepMinutes,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepRecordsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.durationMinutes == this.durationMinutes &&
          other.qualityRating == this.qualityRating &&
          other.deepSleepMinutes == this.deepSleepMinutes &&
          other.remSleepMinutes == this.remSleepMinutes &&
          other.source == this.source);
}

class SleepRecordsTableCompanion
    extends UpdateCompanion<SleepRecordsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> durationMinutes;
  final Value<int> qualityRating;
  final Value<int?> deepSleepMinutes;
  final Value<int?> remSleepMinutes;
  final Value<String> source;
  final Value<int> rowid;
  const SleepRecordsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.qualityRating = const Value.absent(),
    this.deepSleepMinutes = const Value.absent(),
    this.remSleepMinutes = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SleepRecordsTableCompanion.insert({
    required String id,
    required String userId,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    this.qualityRating = const Value.absent(),
    this.deepSleepMinutes = const Value.absent(),
    this.remSleepMinutes = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       startTime = Value(startTime),
       endTime = Value(endTime),
       durationMinutes = Value(durationMinutes);
  static Insertable<SleepRecordsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? durationMinutes,
    Expression<int>? qualityRating,
    Expression<int>? deepSleepMinutes,
    Expression<int>? remSleepMinutes,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (qualityRating != null) 'quality_rating': qualityRating,
      if (deepSleepMinutes != null) 'deep_sleep_minutes': deepSleepMinutes,
      if (remSleepMinutes != null) 'rem_sleep_minutes': remSleepMinutes,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SleepRecordsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<int>? durationMinutes,
    Value<int>? qualityRating,
    Value<int?>? deepSleepMinutes,
    Value<int?>? remSleepMinutes,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return SleepRecordsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      qualityRating: qualityRating ?? this.qualityRating,
      deepSleepMinutes: deepSleepMinutes ?? this.deepSleepMinutes,
      remSleepMinutes: remSleepMinutes ?? this.remSleepMinutes,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (qualityRating.present) {
      map['quality_rating'] = Variable<int>(qualityRating.value);
    }
    if (deepSleepMinutes.present) {
      map['deep_sleep_minutes'] = Variable<int>(deepSleepMinutes.value);
    }
    if (remSleepMinutes.present) {
      map['rem_sleep_minutes'] = Variable<int>(remSleepMinutes.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepRecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('qualityRating: $qualityRating, ')
          ..write('deepSleepMinutes: $deepSleepMinutes, ')
          ..write('remSleepMinutes: $remSleepMinutes, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WaterLogsTableTable extends WaterLogsTable
    with TableInfo<$WaterLogsTableTable, WaterLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMlMeta = const VerificationMeta(
    'amountMl',
  );
  @override
  late final GeneratedColumn<int> amountMl = GeneratedColumn<int>(
    'amount_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyGoalMlMeta = const VerificationMeta(
    'dailyGoalMl',
  );
  @override
  late final GeneratedColumn<int> dailyGoalMl = GeneratedColumn<int>(
    'daily_goal_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2500),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    recordedAt,
    amountMl,
    dailyGoalMl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterLogsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('amount_ml')) {
      context.handle(
        _amountMlMeta,
        amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMlMeta);
    }
    if (data.containsKey('daily_goal_ml')) {
      context.handle(
        _dailyGoalMlMeta,
        dailyGoalMl.isAcceptableOrUnknown(
          data['daily_goal_ml']!,
          _dailyGoalMlMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterLogsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      amountMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_ml'],
      )!,
      dailyGoalMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal_ml'],
      )!,
    );
  }

  @override
  $WaterLogsTableTable createAlias(String alias) {
    return $WaterLogsTableTable(attachedDatabase, alias);
  }
}

class WaterLogsTableData extends DataClass
    implements Insertable<WaterLogsTableData> {
  final String id;
  final String userId;
  final DateTime recordedAt;
  final int amountMl;
  final int dailyGoalMl;
  const WaterLogsTableData({
    required this.id,
    required this.userId,
    required this.recordedAt,
    required this.amountMl,
    required this.dailyGoalMl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['amount_ml'] = Variable<int>(amountMl);
    map['daily_goal_ml'] = Variable<int>(dailyGoalMl);
    return map;
  }

  WaterLogsTableCompanion toCompanion(bool nullToAbsent) {
    return WaterLogsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      recordedAt: Value(recordedAt),
      amountMl: Value(amountMl),
      dailyGoalMl: Value(dailyGoalMl),
    );
  }

  factory WaterLogsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterLogsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      amountMl: serializer.fromJson<int>(json['amountMl']),
      dailyGoalMl: serializer.fromJson<int>(json['dailyGoalMl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'amountMl': serializer.toJson<int>(amountMl),
      'dailyGoalMl': serializer.toJson<int>(dailyGoalMl),
    };
  }

  WaterLogsTableData copyWith({
    String? id,
    String? userId,
    DateTime? recordedAt,
    int? amountMl,
    int? dailyGoalMl,
  }) => WaterLogsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    recordedAt: recordedAt ?? this.recordedAt,
    amountMl: amountMl ?? this.amountMl,
    dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
  );
  WaterLogsTableData copyWithCompanion(WaterLogsTableCompanion data) {
    return WaterLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      dailyGoalMl: data.dailyGoalMl.present
          ? data.dailyGoalMl.value
          : this.dailyGoalMl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('amountMl: $amountMl, ')
          ..write('dailyGoalMl: $dailyGoalMl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, recordedAt, amountMl, dailyGoalMl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterLogsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.recordedAt == this.recordedAt &&
          other.amountMl == this.amountMl &&
          other.dailyGoalMl == this.dailyGoalMl);
}

class WaterLogsTableCompanion extends UpdateCompanion<WaterLogsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> recordedAt;
  final Value<int> amountMl;
  final Value<int> dailyGoalMl;
  final Value<int> rowid;
  const WaterLogsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.dailyGoalMl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WaterLogsTableCompanion.insert({
    required String id,
    required String userId,
    required DateTime recordedAt,
    required int amountMl,
    this.dailyGoalMl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       recordedAt = Value(recordedAt),
       amountMl = Value(amountMl);
  static Insertable<WaterLogsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? recordedAt,
    Expression<int>? amountMl,
    Expression<int>? dailyGoalMl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (amountMl != null) 'amount_ml': amountMl,
      if (dailyGoalMl != null) 'daily_goal_ml': dailyGoalMl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WaterLogsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? recordedAt,
    Value<int>? amountMl,
    Value<int>? dailyGoalMl,
    Value<int>? rowid,
  }) {
    return WaterLogsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recordedAt: recordedAt ?? this.recordedAt,
      amountMl: amountMl ?? this.amountMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<int>(amountMl.value);
    }
    if (dailyGoalMl.present) {
      map['daily_goal_ml'] = Variable<int>(dailyGoalMl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('amountMl: $amountMl, ')
          ..write('dailyGoalMl: $dailyGoalMl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoodLogsTableTable extends MoodLogsTable
    with TableInfo<$MoodLogsTableTable, MoodLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodScoreMeta = const VerificationMeta(
    'moodScore',
  );
  @override
  late final GeneratedColumn<int> moodScore = GeneratedColumn<int>(
    'mood_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    recordedAt,
    moodScore,
    notes,
    tagsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodLogsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('mood_score')) {
      context.handle(
        _moodScoreMeta,
        moodScore.isAcceptableOrUnknown(data['mood_score']!, _moodScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_moodScoreMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodLogsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      moodScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_score'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      ),
    );
  }

  @override
  $MoodLogsTableTable createAlias(String alias) {
    return $MoodLogsTableTable(attachedDatabase, alias);
  }
}

class MoodLogsTableData extends DataClass
    implements Insertable<MoodLogsTableData> {
  final String id;
  final String userId;
  final DateTime recordedAt;
  final int moodScore;
  final String? notes;
  final String? tagsJson;
  const MoodLogsTableData({
    required this.id,
    required this.userId,
    required this.recordedAt,
    required this.moodScore,
    this.notes,
    this.tagsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['mood_score'] = Variable<int>(moodScore);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || tagsJson != null) {
      map['tags_json'] = Variable<String>(tagsJson);
    }
    return map;
  }

  MoodLogsTableCompanion toCompanion(bool nullToAbsent) {
    return MoodLogsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      recordedAt: Value(recordedAt),
      moodScore: Value(moodScore),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      tagsJson: tagsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(tagsJson),
    );
  }

  factory MoodLogsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodLogsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      moodScore: serializer.fromJson<int>(json['moodScore']),
      notes: serializer.fromJson<String?>(json['notes']),
      tagsJson: serializer.fromJson<String?>(json['tagsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'moodScore': serializer.toJson<int>(moodScore),
      'notes': serializer.toJson<String?>(notes),
      'tagsJson': serializer.toJson<String?>(tagsJson),
    };
  }

  MoodLogsTableData copyWith({
    String? id,
    String? userId,
    DateTime? recordedAt,
    int? moodScore,
    Value<String?> notes = const Value.absent(),
    Value<String?> tagsJson = const Value.absent(),
  }) => MoodLogsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    recordedAt: recordedAt ?? this.recordedAt,
    moodScore: moodScore ?? this.moodScore,
    notes: notes.present ? notes.value : this.notes,
    tagsJson: tagsJson.present ? tagsJson.value : this.tagsJson,
  );
  MoodLogsTableData copyWithCompanion(MoodLogsTableCompanion data) {
    return MoodLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      moodScore: data.moodScore.present ? data.moodScore.value : this.moodScore,
      notes: data.notes.present ? data.notes.value : this.notes,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodLogsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('moodScore: $moodScore, ')
          ..write('notes: $notes, ')
          ..write('tagsJson: $tagsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, recordedAt, moodScore, notes, tagsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodLogsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.recordedAt == this.recordedAt &&
          other.moodScore == this.moodScore &&
          other.notes == this.notes &&
          other.tagsJson == this.tagsJson);
}

class MoodLogsTableCompanion extends UpdateCompanion<MoodLogsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> recordedAt;
  final Value<int> moodScore;
  final Value<String?> notes;
  final Value<String?> tagsJson;
  final Value<int> rowid;
  const MoodLogsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.moodScore = const Value.absent(),
    this.notes = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodLogsTableCompanion.insert({
    required String id,
    required String userId,
    required DateTime recordedAt,
    required int moodScore,
    this.notes = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       recordedAt = Value(recordedAt),
       moodScore = Value(moodScore);
  static Insertable<MoodLogsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? recordedAt,
    Expression<int>? moodScore,
    Expression<String>? notes,
    Expression<String>? tagsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (moodScore != null) 'mood_score': moodScore,
      if (notes != null) 'notes': notes,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodLogsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? recordedAt,
    Value<int>? moodScore,
    Value<String?>? notes,
    Value<String?>? tagsJson,
    Value<int>? rowid,
  }) {
    return MoodLogsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recordedAt: recordedAt ?? this.recordedAt,
      moodScore: moodScore ?? this.moodScore,
      notes: notes ?? this.notes,
      tagsJson: tagsJson ?? this.tagsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (moodScore.present) {
      map['mood_score'] = Variable<int>(moodScore.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('moodScore: $moodScore, ')
          ..write('notes: $notes, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VitalRecordsTableTable extends VitalRecordsTable
    with TableInfo<$VitalRecordsTableTable, VitalRecordsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VitalRecordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitalTypeMeta = const VerificationMeta(
    'vitalType',
  );
  @override
  late final GeneratedColumn<String> vitalType = GeneratedColumn<String>(
    'vital_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _systolicMeta = const VerificationMeta(
    'systolic',
  );
  @override
  late final GeneratedColumn<int> systolic = GeneratedColumn<int>(
    'systolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diastolicMeta = const VerificationMeta(
    'diastolic',
  );
  @override
  late final GeneratedColumn<int> diastolic = GeneratedColumn<int>(
    'diastolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pulseMeta = const VerificationMeta('pulse');
  @override
  late final GeneratedColumn<int> pulse = GeneratedColumn<int>(
    'pulse',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _glucoseMgDlMeta = const VerificationMeta(
    'glucoseMgDl',
  );
  @override
  late final GeneratedColumn<double> glucoseMgDl = GeneratedColumn<double>(
    'glucose_mg_dl',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contextTagMeta = const VerificationMeta(
    'contextTag',
  );
  @override
  late final GeneratedColumn<String> contextTag = GeneratedColumn<String>(
    'context_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    recordedAt,
    vitalType,
    systolic,
    diastolic,
    pulse,
    glucoseMgDl,
    contextTag,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vital_records_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<VitalRecordsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('vital_type')) {
      context.handle(
        _vitalTypeMeta,
        vitalType.isAcceptableOrUnknown(data['vital_type']!, _vitalTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_vitalTypeMeta);
    }
    if (data.containsKey('systolic')) {
      context.handle(
        _systolicMeta,
        systolic.isAcceptableOrUnknown(data['systolic']!, _systolicMeta),
      );
    }
    if (data.containsKey('diastolic')) {
      context.handle(
        _diastolicMeta,
        diastolic.isAcceptableOrUnknown(data['diastolic']!, _diastolicMeta),
      );
    }
    if (data.containsKey('pulse')) {
      context.handle(
        _pulseMeta,
        pulse.isAcceptableOrUnknown(data['pulse']!, _pulseMeta),
      );
    }
    if (data.containsKey('glucose_mg_dl')) {
      context.handle(
        _glucoseMgDlMeta,
        glucoseMgDl.isAcceptableOrUnknown(
          data['glucose_mg_dl']!,
          _glucoseMgDlMeta,
        ),
      );
    }
    if (data.containsKey('context_tag')) {
      context.handle(
        _contextTagMeta,
        contextTag.isAcceptableOrUnknown(data['context_tag']!, _contextTagMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VitalRecordsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VitalRecordsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      vitalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vital_type'],
      )!,
      systolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}systolic'],
      ),
      diastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diastolic'],
      ),
      pulse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pulse'],
      ),
      glucoseMgDl: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}glucose_mg_dl'],
      ),
      contextTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_tag'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $VitalRecordsTableTable createAlias(String alias) {
    return $VitalRecordsTableTable(attachedDatabase, alias);
  }
}

class VitalRecordsTableData extends DataClass
    implements Insertable<VitalRecordsTableData> {
  final String id;
  final String userId;
  final DateTime recordedAt;
  final String vitalType;
  final int? systolic;
  final int? diastolic;
  final int? pulse;
  final double? glucoseMgDl;
  final String? contextTag;
  final String source;
  const VitalRecordsTableData({
    required this.id,
    required this.userId,
    required this.recordedAt,
    required this.vitalType,
    this.systolic,
    this.diastolic,
    this.pulse,
    this.glucoseMgDl,
    this.contextTag,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['vital_type'] = Variable<String>(vitalType);
    if (!nullToAbsent || systolic != null) {
      map['systolic'] = Variable<int>(systolic);
    }
    if (!nullToAbsent || diastolic != null) {
      map['diastolic'] = Variable<int>(diastolic);
    }
    if (!nullToAbsent || pulse != null) {
      map['pulse'] = Variable<int>(pulse);
    }
    if (!nullToAbsent || glucoseMgDl != null) {
      map['glucose_mg_dl'] = Variable<double>(glucoseMgDl);
    }
    if (!nullToAbsent || contextTag != null) {
      map['context_tag'] = Variable<String>(contextTag);
    }
    map['source'] = Variable<String>(source);
    return map;
  }

  VitalRecordsTableCompanion toCompanion(bool nullToAbsent) {
    return VitalRecordsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      recordedAt: Value(recordedAt),
      vitalType: Value(vitalType),
      systolic: systolic == null && nullToAbsent
          ? const Value.absent()
          : Value(systolic),
      diastolic: diastolic == null && nullToAbsent
          ? const Value.absent()
          : Value(diastolic),
      pulse: pulse == null && nullToAbsent
          ? const Value.absent()
          : Value(pulse),
      glucoseMgDl: glucoseMgDl == null && nullToAbsent
          ? const Value.absent()
          : Value(glucoseMgDl),
      contextTag: contextTag == null && nullToAbsent
          ? const Value.absent()
          : Value(contextTag),
      source: Value(source),
    );
  }

  factory VitalRecordsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VitalRecordsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      vitalType: serializer.fromJson<String>(json['vitalType']),
      systolic: serializer.fromJson<int?>(json['systolic']),
      diastolic: serializer.fromJson<int?>(json['diastolic']),
      pulse: serializer.fromJson<int?>(json['pulse']),
      glucoseMgDl: serializer.fromJson<double?>(json['glucoseMgDl']),
      contextTag: serializer.fromJson<String?>(json['contextTag']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'vitalType': serializer.toJson<String>(vitalType),
      'systolic': serializer.toJson<int?>(systolic),
      'diastolic': serializer.toJson<int?>(diastolic),
      'pulse': serializer.toJson<int?>(pulse),
      'glucoseMgDl': serializer.toJson<double?>(glucoseMgDl),
      'contextTag': serializer.toJson<String?>(contextTag),
      'source': serializer.toJson<String>(source),
    };
  }

  VitalRecordsTableData copyWith({
    String? id,
    String? userId,
    DateTime? recordedAt,
    String? vitalType,
    Value<int?> systolic = const Value.absent(),
    Value<int?> diastolic = const Value.absent(),
    Value<int?> pulse = const Value.absent(),
    Value<double?> glucoseMgDl = const Value.absent(),
    Value<String?> contextTag = const Value.absent(),
    String? source,
  }) => VitalRecordsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    recordedAt: recordedAt ?? this.recordedAt,
    vitalType: vitalType ?? this.vitalType,
    systolic: systolic.present ? systolic.value : this.systolic,
    diastolic: diastolic.present ? diastolic.value : this.diastolic,
    pulse: pulse.present ? pulse.value : this.pulse,
    glucoseMgDl: glucoseMgDl.present ? glucoseMgDl.value : this.glucoseMgDl,
    contextTag: contextTag.present ? contextTag.value : this.contextTag,
    source: source ?? this.source,
  );
  VitalRecordsTableData copyWithCompanion(VitalRecordsTableCompanion data) {
    return VitalRecordsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      vitalType: data.vitalType.present ? data.vitalType.value : this.vitalType,
      systolic: data.systolic.present ? data.systolic.value : this.systolic,
      diastolic: data.diastolic.present ? data.diastolic.value : this.diastolic,
      pulse: data.pulse.present ? data.pulse.value : this.pulse,
      glucoseMgDl: data.glucoseMgDl.present
          ? data.glucoseMgDl.value
          : this.glucoseMgDl,
      contextTag: data.contextTag.present
          ? data.contextTag.value
          : this.contextTag,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VitalRecordsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('vitalType: $vitalType, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('pulse: $pulse, ')
          ..write('glucoseMgDl: $glucoseMgDl, ')
          ..write('contextTag: $contextTag, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    recordedAt,
    vitalType,
    systolic,
    diastolic,
    pulse,
    glucoseMgDl,
    contextTag,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VitalRecordsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.recordedAt == this.recordedAt &&
          other.vitalType == this.vitalType &&
          other.systolic == this.systolic &&
          other.diastolic == this.diastolic &&
          other.pulse == this.pulse &&
          other.glucoseMgDl == this.glucoseMgDl &&
          other.contextTag == this.contextTag &&
          other.source == this.source);
}

class VitalRecordsTableCompanion
    extends UpdateCompanion<VitalRecordsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> recordedAt;
  final Value<String> vitalType;
  final Value<int?> systolic;
  final Value<int?> diastolic;
  final Value<int?> pulse;
  final Value<double?> glucoseMgDl;
  final Value<String?> contextTag;
  final Value<String> source;
  final Value<int> rowid;
  const VitalRecordsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.vitalType = const Value.absent(),
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.pulse = const Value.absent(),
    this.glucoseMgDl = const Value.absent(),
    this.contextTag = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VitalRecordsTableCompanion.insert({
    required String id,
    required String userId,
    required DateTime recordedAt,
    required String vitalType,
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.pulse = const Value.absent(),
    this.glucoseMgDl = const Value.absent(),
    this.contextTag = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       recordedAt = Value(recordedAt),
       vitalType = Value(vitalType);
  static Insertable<VitalRecordsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? recordedAt,
    Expression<String>? vitalType,
    Expression<int>? systolic,
    Expression<int>? diastolic,
    Expression<int>? pulse,
    Expression<double>? glucoseMgDl,
    Expression<String>? contextTag,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (vitalType != null) 'vital_type': vitalType,
      if (systolic != null) 'systolic': systolic,
      if (diastolic != null) 'diastolic': diastolic,
      if (pulse != null) 'pulse': pulse,
      if (glucoseMgDl != null) 'glucose_mg_dl': glucoseMgDl,
      if (contextTag != null) 'context_tag': contextTag,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VitalRecordsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? recordedAt,
    Value<String>? vitalType,
    Value<int?>? systolic,
    Value<int?>? diastolic,
    Value<int?>? pulse,
    Value<double?>? glucoseMgDl,
    Value<String?>? contextTag,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return VitalRecordsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recordedAt: recordedAt ?? this.recordedAt,
      vitalType: vitalType ?? this.vitalType,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      pulse: pulse ?? this.pulse,
      glucoseMgDl: glucoseMgDl ?? this.glucoseMgDl,
      contextTag: contextTag ?? this.contextTag,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (vitalType.present) {
      map['vital_type'] = Variable<String>(vitalType.value);
    }
    if (systolic.present) {
      map['systolic'] = Variable<int>(systolic.value);
    }
    if (diastolic.present) {
      map['diastolic'] = Variable<int>(diastolic.value);
    }
    if (pulse.present) {
      map['pulse'] = Variable<int>(pulse.value);
    }
    if (glucoseMgDl.present) {
      map['glucose_mg_dl'] = Variable<double>(glucoseMgDl.value);
    }
    if (contextTag.present) {
      map['context_tag'] = Variable<String>(contextTag.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VitalRecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('vitalType: $vitalType, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('pulse: $pulse, ')
          ..write('glucoseMgDl: $glucoseMgDl, ')
          ..write('contextTag: $contextTag, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationEntriesTableTable extends MedicationEntriesTable
    with TableInfo<$MedicationEntriesTableTable, MedicationEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeOfDayMeta = const VerificationMeta(
    'timeOfDay',
  );
  @override
  late final GeneratedColumn<String> timeOfDay = GeneratedColumn<String>(
    'time_of_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('scheduled'),
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>(
        'scheduled_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    dosage,
    timeOfDay,
    status,
    scheduledDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_entries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    } else if (isInserting) {
      context.missing(_dosageMeta);
    }
    if (data.containsKey('time_of_day')) {
      context.handle(
        _timeOfDayMeta,
        timeOfDay.isAcceptableOrUnknown(data['time_of_day']!, _timeOfDayMeta),
      );
    } else if (isInserting) {
      context.missing(_timeOfDayMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationEntriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationEntriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      )!,
      timeOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_of_day'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      scheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_date'],
      )!,
    );
  }

  @override
  $MedicationEntriesTableTable createAlias(String alias) {
    return $MedicationEntriesTableTable(attachedDatabase, alias);
  }
}

class MedicationEntriesTableData extends DataClass
    implements Insertable<MedicationEntriesTableData> {
  final String id;
  final String userId;
  final String name;
  final String dosage;
  final String timeOfDay;
  final String status;
  final DateTime scheduledDate;
  const MedicationEntriesTableData({
    required this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    required this.timeOfDay,
    required this.status,
    required this.scheduledDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['dosage'] = Variable<String>(dosage);
    map['time_of_day'] = Variable<String>(timeOfDay);
    map['status'] = Variable<String>(status);
    map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    return map;
  }

  MedicationEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return MedicationEntriesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      dosage: Value(dosage),
      timeOfDay: Value(timeOfDay),
      status: Value(status),
      scheduledDate: Value(scheduledDate),
    );
  }

  factory MedicationEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String>(json['dosage']),
      timeOfDay: serializer.fromJson<String>(json['timeOfDay']),
      status: serializer.fromJson<String>(json['status']),
      scheduledDate: serializer.fromJson<DateTime>(json['scheduledDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String>(dosage),
      'timeOfDay': serializer.toJson<String>(timeOfDay),
      'status': serializer.toJson<String>(status),
      'scheduledDate': serializer.toJson<DateTime>(scheduledDate),
    };
  }

  MedicationEntriesTableData copyWith({
    String? id,
    String? userId,
    String? name,
    String? dosage,
    String? timeOfDay,
    String? status,
    DateTime? scheduledDate,
  }) => MedicationEntriesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    dosage: dosage ?? this.dosage,
    timeOfDay: timeOfDay ?? this.timeOfDay,
    status: status ?? this.status,
    scheduledDate: scheduledDate ?? this.scheduledDate,
  );
  MedicationEntriesTableData copyWithCompanion(
    MedicationEntriesTableCompanion data,
  ) {
    return MedicationEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      timeOfDay: data.timeOfDay.present ? data.timeOfDay.value : this.timeOfDay,
      status: data.status.present ? data.status.value : this.status,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationEntriesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('status: $status, ')
          ..write('scheduledDate: $scheduledDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, name, dosage, timeOfDay, status, scheduledDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationEntriesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.dosage == this.dosage &&
          other.timeOfDay == this.timeOfDay &&
          other.status == this.status &&
          other.scheduledDate == this.scheduledDate);
}

class MedicationEntriesTableCompanion
    extends UpdateCompanion<MedicationEntriesTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> dosage;
  final Value<String> timeOfDay;
  final Value<String> status;
  final Value<DateTime> scheduledDate;
  final Value<int> rowid;
  const MedicationEntriesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.timeOfDay = const Value.absent(),
    this.status = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationEntriesTableCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String dosage,
    required String timeOfDay,
    this.status = const Value.absent(),
    required DateTime scheduledDate,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       dosage = Value(dosage),
       timeOfDay = Value(timeOfDay),
       scheduledDate = Value(scheduledDate);
  static Insertable<MedicationEntriesTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<String>? timeOfDay,
    Expression<String>? status,
    Expression<DateTime>? scheduledDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (timeOfDay != null) 'time_of_day': timeOfDay,
      if (status != null) 'status': status,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<String>? dosage,
    Value<String>? timeOfDay,
    Value<String>? status,
    Value<DateTime>? scheduledDate,
    Value<int>? rowid,
  }) {
    return MedicationEntriesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (timeOfDay.present) {
      map['time_of_day'] = Variable<String>(timeOfDay.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('status: $status, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitEntriesTableTable extends HabitEntriesTable
    with TableInfo<$HabitEntriesTableTable, HabitEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('daily'),
  );
  static const VerificationMeta _targetDaysMeta = const VerificationMeta(
    'targetDays',
  );
  @override
  late final GeneratedColumn<int> targetDays = GeneratedColumn<int>(
    'target_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestStreakMeta = const VerificationMeta(
    'bestStreak',
  );
  @override
  late final GeneratedColumn<int> bestStreak = GeneratedColumn<int>(
    'best_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastCompletedAtMeta = const VerificationMeta(
    'lastCompletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastCompletedAt =
      GeneratedColumn<DateTime>(
        'last_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    frequency,
    targetDays,
    currentStreak,
    bestStreak,
    lastCompletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_entries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('target_days')) {
      context.handle(
        _targetDaysMeta,
        targetDays.isAcceptableOrUnknown(data['target_days']!, _targetDaysMeta),
      );
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('best_streak')) {
      context.handle(
        _bestStreakMeta,
        bestStreak.isAcceptableOrUnknown(data['best_streak']!, _bestStreakMeta),
      );
    }
    if (data.containsKey('last_completed_at')) {
      context.handle(
        _lastCompletedAtMeta,
        lastCompletedAt.isAcceptableOrUnknown(
          data['last_completed_at']!,
          _lastCompletedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitEntriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitEntriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      targetDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_days'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      bestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_streak'],
      )!,
      lastCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_completed_at'],
      ),
    );
  }

  @override
  $HabitEntriesTableTable createAlias(String alias) {
    return $HabitEntriesTableTable(attachedDatabase, alias);
  }
}

class HabitEntriesTableData extends DataClass
    implements Insertable<HabitEntriesTableData> {
  final String id;
  final String userId;
  final String title;
  final String frequency;
  final int targetDays;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastCompletedAt;
  const HabitEntriesTableData({
    required this.id,
    required this.userId,
    required this.title,
    required this.frequency,
    required this.targetDays,
    required this.currentStreak,
    required this.bestStreak,
    this.lastCompletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['frequency'] = Variable<String>(frequency);
    map['target_days'] = Variable<int>(targetDays);
    map['current_streak'] = Variable<int>(currentStreak);
    map['best_streak'] = Variable<int>(bestStreak);
    if (!nullToAbsent || lastCompletedAt != null) {
      map['last_completed_at'] = Variable<DateTime>(lastCompletedAt);
    }
    return map;
  }

  HabitEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return HabitEntriesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      frequency: Value(frequency),
      targetDays: Value(targetDays),
      currentStreak: Value(currentStreak),
      bestStreak: Value(bestStreak),
      lastCompletedAt: lastCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedAt),
    );
  }

  factory HabitEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      frequency: serializer.fromJson<String>(json['frequency']),
      targetDays: serializer.fromJson<int>(json['targetDays']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      bestStreak: serializer.fromJson<int>(json['bestStreak']),
      lastCompletedAt: serializer.fromJson<DateTime?>(json['lastCompletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'frequency': serializer.toJson<String>(frequency),
      'targetDays': serializer.toJson<int>(targetDays),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'bestStreak': serializer.toJson<int>(bestStreak),
      'lastCompletedAt': serializer.toJson<DateTime?>(lastCompletedAt),
    };
  }

  HabitEntriesTableData copyWith({
    String? id,
    String? userId,
    String? title,
    String? frequency,
    int? targetDays,
    int? currentStreak,
    int? bestStreak,
    Value<DateTime?> lastCompletedAt = const Value.absent(),
  }) => HabitEntriesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    frequency: frequency ?? this.frequency,
    targetDays: targetDays ?? this.targetDays,
    currentStreak: currentStreak ?? this.currentStreak,
    bestStreak: bestStreak ?? this.bestStreak,
    lastCompletedAt: lastCompletedAt.present
        ? lastCompletedAt.value
        : this.lastCompletedAt,
  );
  HabitEntriesTableData copyWithCompanion(HabitEntriesTableCompanion data) {
    return HabitEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      targetDays: data.targetDays.present
          ? data.targetDays.value
          : this.targetDays,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      bestStreak: data.bestStreak.present
          ? data.bestStreak.value
          : this.bestStreak,
      lastCompletedAt: data.lastCompletedAt.present
          ? data.lastCompletedAt.value
          : this.lastCompletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntriesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('frequency: $frequency, ')
          ..write('targetDays: $targetDays, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('lastCompletedAt: $lastCompletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    title,
    frequency,
    targetDays,
    currentStreak,
    bestStreak,
    lastCompletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitEntriesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.frequency == this.frequency &&
          other.targetDays == this.targetDays &&
          other.currentStreak == this.currentStreak &&
          other.bestStreak == this.bestStreak &&
          other.lastCompletedAt == this.lastCompletedAt);
}

class HabitEntriesTableCompanion
    extends UpdateCompanion<HabitEntriesTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> frequency;
  final Value<int> targetDays;
  final Value<int> currentStreak;
  final Value<int> bestStreak;
  final Value<DateTime?> lastCompletedAt;
  final Value<int> rowid;
  const HabitEntriesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.frequency = const Value.absent(),
    this.targetDays = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.lastCompletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitEntriesTableCompanion.insert({
    required String id,
    required String userId,
    required String title,
    this.frequency = const Value.absent(),
    this.targetDays = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.lastCompletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title);
  static Insertable<HabitEntriesTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? frequency,
    Expression<int>? targetDays,
    Expression<int>? currentStreak,
    Expression<int>? bestStreak,
    Expression<DateTime>? lastCompletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (frequency != null) 'frequency': frequency,
      if (targetDays != null) 'target_days': targetDays,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (bestStreak != null) 'best_streak': bestStreak,
      if (lastCompletedAt != null) 'last_completed_at': lastCompletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<String>? frequency,
    Value<int>? targetDays,
    Value<int>? currentStreak,
    Value<int>? bestStreak,
    Value<DateTime?>? lastCompletedAt,
    Value<int>? rowid,
  }) {
    return HabitEntriesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      frequency: frequency ?? this.frequency,
      targetDays: targetDays ?? this.targetDays,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (targetDays.present) {
      map['target_days'] = Variable<int>(targetDays.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (bestStreak.present) {
      map['best_streak'] = Variable<int>(bestStreak.value);
    }
    if (lastCompletedAt.present) {
      map['last_completed_at'] = Variable<DateTime>(lastCompletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('frequency: $frequency, ')
          ..write('targetDays: $targetDays, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('lastCompletedAt: $lastCompletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodCatalogEntriesTableTable extends FoodCatalogEntriesTable
    with TableInfo<$FoodCatalogEntriesTableTable, FoodCatalogEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodCatalogEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hindiNameMeta = const VerificationMeta(
    'hindiName',
  );
  @override
  late final GeneratedColumn<String> hindiName = GeneratedColumn<String>(
    'hindi_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesPer100gMeta = const VerificationMeta(
    'caloriesPer100g',
  );
  @override
  late final GeneratedColumn<double> caloriesPer100g = GeneratedColumn<double>(
    'calories_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinPer100gMeta = const VerificationMeta(
    'proteinPer100g',
  );
  @override
  late final GeneratedColumn<double> proteinPer100g = GeneratedColumn<double>(
    'protein_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsPer100gMeta = const VerificationMeta(
    'carbsPer100g',
  );
  @override
  late final GeneratedColumn<double> carbsPer100g = GeneratedColumn<double>(
    'carbs_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatPer100gMeta = const VerificationMeta(
    'fatPer100g',
  );
  @override
  late final GeneratedColumn<double> fatPer100g = GeneratedColumn<double>(
    'fat_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberPer100gMeta = const VerificationMeta(
    'fiberPer100g',
  );
  @override
  late final GeneratedColumn<double> fiberPer100g = GeneratedColumn<double>(
    'fiber_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isVegetarianMeta = const VerificationMeta(
    'isVegetarian',
  );
  @override
  late final GeneratedColumn<bool> isVegetarian = GeneratedColumn<bool>(
    'is_vegetarian',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_vegetarian" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isEggMeta = const VerificationMeta('isEgg');
  @override
  late final GeneratedColumn<bool> isEgg = GeneratedColumn<bool>(
    'is_egg',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_egg" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isVeganMeta = const VerificationMeta(
    'isVegan',
  );
  @override
  late final GeneratedColumn<bool> isVegan = GeneratedColumn<bool>(
    'is_vegan',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_vegan" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cuisineRegionMeta = const VerificationMeta(
    'cuisineRegion',
  );
  @override
  late final GeneratedColumn<String> cuisineRegion = GeneratedColumn<String>(
    'cuisine_region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Pan-Indian'),
  );
  static const VerificationMeta _defaultPortionUnitMeta =
      const VerificationMeta('defaultPortionUnit');
  @override
  late final GeneratedColumn<String> defaultPortionUnit =
      GeneratedColumn<String>(
        'default_portion_unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('mediumKatori'),
      );
  static const VerificationMeta _basePortionGramsMeta = const VerificationMeta(
    'basePortionGrams',
  );
  @override
  late final GeneratedColumn<double> basePortionGrams = GeneratedColumn<double>(
    'base_portion_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(100.0),
  );
  static const VerificationMeta _provenanceMeta = const VerificationMeta(
    'provenance',
  );
  @override
  late final GeneratedColumn<String> provenance = GeneratedColumn<String>(
    'provenance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ICMR-NIN 2024 / IFCT Standard'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    hindiName,
    category,
    caloriesPer100g,
    proteinPer100g,
    carbsPer100g,
    fatPer100g,
    fiberPer100g,
    isVegetarian,
    isEgg,
    isVegan,
    cuisineRegion,
    defaultPortionUnit,
    basePortionGrams,
    provenance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_catalog_entries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodCatalogEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('hindi_name')) {
      context.handle(
        _hindiNameMeta,
        hindiName.isAcceptableOrUnknown(data['hindi_name']!, _hindiNameMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('calories_per100g')) {
      context.handle(
        _caloriesPer100gMeta,
        caloriesPer100g.isAcceptableOrUnknown(
          data['calories_per100g']!,
          _caloriesPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesPer100gMeta);
    }
    if (data.containsKey('protein_per100g')) {
      context.handle(
        _proteinPer100gMeta,
        proteinPer100g.isAcceptableOrUnknown(
          data['protein_per100g']!,
          _proteinPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinPer100gMeta);
    }
    if (data.containsKey('carbs_per100g')) {
      context.handle(
        _carbsPer100gMeta,
        carbsPer100g.isAcceptableOrUnknown(
          data['carbs_per100g']!,
          _carbsPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbsPer100gMeta);
    }
    if (data.containsKey('fat_per100g')) {
      context.handle(
        _fatPer100gMeta,
        fatPer100g.isAcceptableOrUnknown(data['fat_per100g']!, _fatPer100gMeta),
      );
    } else if (isInserting) {
      context.missing(_fatPer100gMeta);
    }
    if (data.containsKey('fiber_per100g')) {
      context.handle(
        _fiberPer100gMeta,
        fiberPer100g.isAcceptableOrUnknown(
          data['fiber_per100g']!,
          _fiberPer100gMeta,
        ),
      );
    }
    if (data.containsKey('is_vegetarian')) {
      context.handle(
        _isVegetarianMeta,
        isVegetarian.isAcceptableOrUnknown(
          data['is_vegetarian']!,
          _isVegetarianMeta,
        ),
      );
    }
    if (data.containsKey('is_egg')) {
      context.handle(
        _isEggMeta,
        isEgg.isAcceptableOrUnknown(data['is_egg']!, _isEggMeta),
      );
    }
    if (data.containsKey('is_vegan')) {
      context.handle(
        _isVeganMeta,
        isVegan.isAcceptableOrUnknown(data['is_vegan']!, _isVeganMeta),
      );
    }
    if (data.containsKey('cuisine_region')) {
      context.handle(
        _cuisineRegionMeta,
        cuisineRegion.isAcceptableOrUnknown(
          data['cuisine_region']!,
          _cuisineRegionMeta,
        ),
      );
    }
    if (data.containsKey('default_portion_unit')) {
      context.handle(
        _defaultPortionUnitMeta,
        defaultPortionUnit.isAcceptableOrUnknown(
          data['default_portion_unit']!,
          _defaultPortionUnitMeta,
        ),
      );
    }
    if (data.containsKey('base_portion_grams')) {
      context.handle(
        _basePortionGramsMeta,
        basePortionGrams.isAcceptableOrUnknown(
          data['base_portion_grams']!,
          _basePortionGramsMeta,
        ),
      );
    }
    if (data.containsKey('provenance')) {
      context.handle(
        _provenanceMeta,
        provenance.isAcceptableOrUnknown(data['provenance']!, _provenanceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodCatalogEntriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodCatalogEntriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      hindiName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hindi_name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      caloriesPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_per100g'],
      )!,
      proteinPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_per100g'],
      )!,
      carbsPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_per100g'],
      )!,
      fatPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_per100g'],
      )!,
      fiberPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_per100g'],
      )!,
      isVegetarian: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_vegetarian'],
      )!,
      isEgg: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_egg'],
      )!,
      isVegan: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_vegan'],
      )!,
      cuisineRegion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuisine_region'],
      )!,
      defaultPortionUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_portion_unit'],
      )!,
      basePortionGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}base_portion_grams'],
      )!,
      provenance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provenance'],
      )!,
    );
  }

  @override
  $FoodCatalogEntriesTableTable createAlias(String alias) {
    return $FoodCatalogEntriesTableTable(attachedDatabase, alias);
  }
}

class FoodCatalogEntriesTableData extends DataClass
    implements Insertable<FoodCatalogEntriesTableData> {
  final String id;
  final String name;
  final String hindiName;
  final String category;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double fiberPer100g;
  final bool isVegetarian;
  final bool isEgg;
  final bool isVegan;
  final String cuisineRegion;
  final String defaultPortionUnit;
  final double basePortionGrams;
  final String provenance;
  const FoodCatalogEntriesTableData({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.category,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.fiberPer100g,
    required this.isVegetarian,
    required this.isEgg,
    required this.isVegan,
    required this.cuisineRegion,
    required this.defaultPortionUnit,
    required this.basePortionGrams,
    required this.provenance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['hindi_name'] = Variable<String>(hindiName);
    map['category'] = Variable<String>(category);
    map['calories_per100g'] = Variable<double>(caloriesPer100g);
    map['protein_per100g'] = Variable<double>(proteinPer100g);
    map['carbs_per100g'] = Variable<double>(carbsPer100g);
    map['fat_per100g'] = Variable<double>(fatPer100g);
    map['fiber_per100g'] = Variable<double>(fiberPer100g);
    map['is_vegetarian'] = Variable<bool>(isVegetarian);
    map['is_egg'] = Variable<bool>(isEgg);
    map['is_vegan'] = Variable<bool>(isVegan);
    map['cuisine_region'] = Variable<String>(cuisineRegion);
    map['default_portion_unit'] = Variable<String>(defaultPortionUnit);
    map['base_portion_grams'] = Variable<double>(basePortionGrams);
    map['provenance'] = Variable<String>(provenance);
    return map;
  }

  FoodCatalogEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return FoodCatalogEntriesTableCompanion(
      id: Value(id),
      name: Value(name),
      hindiName: Value(hindiName),
      category: Value(category),
      caloriesPer100g: Value(caloriesPer100g),
      proteinPer100g: Value(proteinPer100g),
      carbsPer100g: Value(carbsPer100g),
      fatPer100g: Value(fatPer100g),
      fiberPer100g: Value(fiberPer100g),
      isVegetarian: Value(isVegetarian),
      isEgg: Value(isEgg),
      isVegan: Value(isVegan),
      cuisineRegion: Value(cuisineRegion),
      defaultPortionUnit: Value(defaultPortionUnit),
      basePortionGrams: Value(basePortionGrams),
      provenance: Value(provenance),
    );
  }

  factory FoodCatalogEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodCatalogEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      hindiName: serializer.fromJson<String>(json['hindiName']),
      category: serializer.fromJson<String>(json['category']),
      caloriesPer100g: serializer.fromJson<double>(json['caloriesPer100g']),
      proteinPer100g: serializer.fromJson<double>(json['proteinPer100g']),
      carbsPer100g: serializer.fromJson<double>(json['carbsPer100g']),
      fatPer100g: serializer.fromJson<double>(json['fatPer100g']),
      fiberPer100g: serializer.fromJson<double>(json['fiberPer100g']),
      isVegetarian: serializer.fromJson<bool>(json['isVegetarian']),
      isEgg: serializer.fromJson<bool>(json['isEgg']),
      isVegan: serializer.fromJson<bool>(json['isVegan']),
      cuisineRegion: serializer.fromJson<String>(json['cuisineRegion']),
      defaultPortionUnit: serializer.fromJson<String>(
        json['defaultPortionUnit'],
      ),
      basePortionGrams: serializer.fromJson<double>(json['basePortionGrams']),
      provenance: serializer.fromJson<String>(json['provenance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'hindiName': serializer.toJson<String>(hindiName),
      'category': serializer.toJson<String>(category),
      'caloriesPer100g': serializer.toJson<double>(caloriesPer100g),
      'proteinPer100g': serializer.toJson<double>(proteinPer100g),
      'carbsPer100g': serializer.toJson<double>(carbsPer100g),
      'fatPer100g': serializer.toJson<double>(fatPer100g),
      'fiberPer100g': serializer.toJson<double>(fiberPer100g),
      'isVegetarian': serializer.toJson<bool>(isVegetarian),
      'isEgg': serializer.toJson<bool>(isEgg),
      'isVegan': serializer.toJson<bool>(isVegan),
      'cuisineRegion': serializer.toJson<String>(cuisineRegion),
      'defaultPortionUnit': serializer.toJson<String>(defaultPortionUnit),
      'basePortionGrams': serializer.toJson<double>(basePortionGrams),
      'provenance': serializer.toJson<String>(provenance),
    };
  }

  FoodCatalogEntriesTableData copyWith({
    String? id,
    String? name,
    String? hindiName,
    String? category,
    double? caloriesPer100g,
    double? proteinPer100g,
    double? carbsPer100g,
    double? fatPer100g,
    double? fiberPer100g,
    bool? isVegetarian,
    bool? isEgg,
    bool? isVegan,
    String? cuisineRegion,
    String? defaultPortionUnit,
    double? basePortionGrams,
    String? provenance,
  }) => FoodCatalogEntriesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    hindiName: hindiName ?? this.hindiName,
    category: category ?? this.category,
    caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
    proteinPer100g: proteinPer100g ?? this.proteinPer100g,
    carbsPer100g: carbsPer100g ?? this.carbsPer100g,
    fatPer100g: fatPer100g ?? this.fatPer100g,
    fiberPer100g: fiberPer100g ?? this.fiberPer100g,
    isVegetarian: isVegetarian ?? this.isVegetarian,
    isEgg: isEgg ?? this.isEgg,
    isVegan: isVegan ?? this.isVegan,
    cuisineRegion: cuisineRegion ?? this.cuisineRegion,
    defaultPortionUnit: defaultPortionUnit ?? this.defaultPortionUnit,
    basePortionGrams: basePortionGrams ?? this.basePortionGrams,
    provenance: provenance ?? this.provenance,
  );
  FoodCatalogEntriesTableData copyWithCompanion(
    FoodCatalogEntriesTableCompanion data,
  ) {
    return FoodCatalogEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      hindiName: data.hindiName.present ? data.hindiName.value : this.hindiName,
      category: data.category.present ? data.category.value : this.category,
      caloriesPer100g: data.caloriesPer100g.present
          ? data.caloriesPer100g.value
          : this.caloriesPer100g,
      proteinPer100g: data.proteinPer100g.present
          ? data.proteinPer100g.value
          : this.proteinPer100g,
      carbsPer100g: data.carbsPer100g.present
          ? data.carbsPer100g.value
          : this.carbsPer100g,
      fatPer100g: data.fatPer100g.present
          ? data.fatPer100g.value
          : this.fatPer100g,
      fiberPer100g: data.fiberPer100g.present
          ? data.fiberPer100g.value
          : this.fiberPer100g,
      isVegetarian: data.isVegetarian.present
          ? data.isVegetarian.value
          : this.isVegetarian,
      isEgg: data.isEgg.present ? data.isEgg.value : this.isEgg,
      isVegan: data.isVegan.present ? data.isVegan.value : this.isVegan,
      cuisineRegion: data.cuisineRegion.present
          ? data.cuisineRegion.value
          : this.cuisineRegion,
      defaultPortionUnit: data.defaultPortionUnit.present
          ? data.defaultPortionUnit.value
          : this.defaultPortionUnit,
      basePortionGrams: data.basePortionGrams.present
          ? data.basePortionGrams.value
          : this.basePortionGrams,
      provenance: data.provenance.present
          ? data.provenance.value
          : this.provenance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodCatalogEntriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hindiName: $hindiName, ')
          ..write('category: $category, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fatPer100g: $fatPer100g, ')
          ..write('fiberPer100g: $fiberPer100g, ')
          ..write('isVegetarian: $isVegetarian, ')
          ..write('isEgg: $isEgg, ')
          ..write('isVegan: $isVegan, ')
          ..write('cuisineRegion: $cuisineRegion, ')
          ..write('defaultPortionUnit: $defaultPortionUnit, ')
          ..write('basePortionGrams: $basePortionGrams, ')
          ..write('provenance: $provenance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    hindiName,
    category,
    caloriesPer100g,
    proteinPer100g,
    carbsPer100g,
    fatPer100g,
    fiberPer100g,
    isVegetarian,
    isEgg,
    isVegan,
    cuisineRegion,
    defaultPortionUnit,
    basePortionGrams,
    provenance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodCatalogEntriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.hindiName == this.hindiName &&
          other.category == this.category &&
          other.caloriesPer100g == this.caloriesPer100g &&
          other.proteinPer100g == this.proteinPer100g &&
          other.carbsPer100g == this.carbsPer100g &&
          other.fatPer100g == this.fatPer100g &&
          other.fiberPer100g == this.fiberPer100g &&
          other.isVegetarian == this.isVegetarian &&
          other.isEgg == this.isEgg &&
          other.isVegan == this.isVegan &&
          other.cuisineRegion == this.cuisineRegion &&
          other.defaultPortionUnit == this.defaultPortionUnit &&
          other.basePortionGrams == this.basePortionGrams &&
          other.provenance == this.provenance);
}

class FoodCatalogEntriesTableCompanion
    extends UpdateCompanion<FoodCatalogEntriesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> hindiName;
  final Value<String> category;
  final Value<double> caloriesPer100g;
  final Value<double> proteinPer100g;
  final Value<double> carbsPer100g;
  final Value<double> fatPer100g;
  final Value<double> fiberPer100g;
  final Value<bool> isVegetarian;
  final Value<bool> isEgg;
  final Value<bool> isVegan;
  final Value<String> cuisineRegion;
  final Value<String> defaultPortionUnit;
  final Value<double> basePortionGrams;
  final Value<String> provenance;
  final Value<int> rowid;
  const FoodCatalogEntriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hindiName = const Value.absent(),
    this.category = const Value.absent(),
    this.caloriesPer100g = const Value.absent(),
    this.proteinPer100g = const Value.absent(),
    this.carbsPer100g = const Value.absent(),
    this.fatPer100g = const Value.absent(),
    this.fiberPer100g = const Value.absent(),
    this.isVegetarian = const Value.absent(),
    this.isEgg = const Value.absent(),
    this.isVegan = const Value.absent(),
    this.cuisineRegion = const Value.absent(),
    this.defaultPortionUnit = const Value.absent(),
    this.basePortionGrams = const Value.absent(),
    this.provenance = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodCatalogEntriesTableCompanion.insert({
    required String id,
    required String name,
    this.hindiName = const Value.absent(),
    required String category,
    required double caloriesPer100g,
    required double proteinPer100g,
    required double carbsPer100g,
    required double fatPer100g,
    this.fiberPer100g = const Value.absent(),
    this.isVegetarian = const Value.absent(),
    this.isEgg = const Value.absent(),
    this.isVegan = const Value.absent(),
    this.cuisineRegion = const Value.absent(),
    this.defaultPortionUnit = const Value.absent(),
    this.basePortionGrams = const Value.absent(),
    this.provenance = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       caloriesPer100g = Value(caloriesPer100g),
       proteinPer100g = Value(proteinPer100g),
       carbsPer100g = Value(carbsPer100g),
       fatPer100g = Value(fatPer100g);
  static Insertable<FoodCatalogEntriesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? hindiName,
    Expression<String>? category,
    Expression<double>? caloriesPer100g,
    Expression<double>? proteinPer100g,
    Expression<double>? carbsPer100g,
    Expression<double>? fatPer100g,
    Expression<double>? fiberPer100g,
    Expression<bool>? isVegetarian,
    Expression<bool>? isEgg,
    Expression<bool>? isVegan,
    Expression<String>? cuisineRegion,
    Expression<String>? defaultPortionUnit,
    Expression<double>? basePortionGrams,
    Expression<String>? provenance,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hindiName != null) 'hindi_name': hindiName,
      if (category != null) 'category': category,
      if (caloriesPer100g != null) 'calories_per100g': caloriesPer100g,
      if (proteinPer100g != null) 'protein_per100g': proteinPer100g,
      if (carbsPer100g != null) 'carbs_per100g': carbsPer100g,
      if (fatPer100g != null) 'fat_per100g': fatPer100g,
      if (fiberPer100g != null) 'fiber_per100g': fiberPer100g,
      if (isVegetarian != null) 'is_vegetarian': isVegetarian,
      if (isEgg != null) 'is_egg': isEgg,
      if (isVegan != null) 'is_vegan': isVegan,
      if (cuisineRegion != null) 'cuisine_region': cuisineRegion,
      if (defaultPortionUnit != null)
        'default_portion_unit': defaultPortionUnit,
      if (basePortionGrams != null) 'base_portion_grams': basePortionGrams,
      if (provenance != null) 'provenance': provenance,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodCatalogEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? hindiName,
    Value<String>? category,
    Value<double>? caloriesPer100g,
    Value<double>? proteinPer100g,
    Value<double>? carbsPer100g,
    Value<double>? fatPer100g,
    Value<double>? fiberPer100g,
    Value<bool>? isVegetarian,
    Value<bool>? isEgg,
    Value<bool>? isVegan,
    Value<String>? cuisineRegion,
    Value<String>? defaultPortionUnit,
    Value<double>? basePortionGrams,
    Value<String>? provenance,
    Value<int>? rowid,
  }) {
    return FoodCatalogEntriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hindiName: hindiName ?? this.hindiName,
      category: category ?? this.category,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      proteinPer100g: proteinPer100g ?? this.proteinPer100g,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      fatPer100g: fatPer100g ?? this.fatPer100g,
      fiberPer100g: fiberPer100g ?? this.fiberPer100g,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isEgg: isEgg ?? this.isEgg,
      isVegan: isVegan ?? this.isVegan,
      cuisineRegion: cuisineRegion ?? this.cuisineRegion,
      defaultPortionUnit: defaultPortionUnit ?? this.defaultPortionUnit,
      basePortionGrams: basePortionGrams ?? this.basePortionGrams,
      provenance: provenance ?? this.provenance,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hindiName.present) {
      map['hindi_name'] = Variable<String>(hindiName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (caloriesPer100g.present) {
      map['calories_per100g'] = Variable<double>(caloriesPer100g.value);
    }
    if (proteinPer100g.present) {
      map['protein_per100g'] = Variable<double>(proteinPer100g.value);
    }
    if (carbsPer100g.present) {
      map['carbs_per100g'] = Variable<double>(carbsPer100g.value);
    }
    if (fatPer100g.present) {
      map['fat_per100g'] = Variable<double>(fatPer100g.value);
    }
    if (fiberPer100g.present) {
      map['fiber_per100g'] = Variable<double>(fiberPer100g.value);
    }
    if (isVegetarian.present) {
      map['is_vegetarian'] = Variable<bool>(isVegetarian.value);
    }
    if (isEgg.present) {
      map['is_egg'] = Variable<bool>(isEgg.value);
    }
    if (isVegan.present) {
      map['is_vegan'] = Variable<bool>(isVegan.value);
    }
    if (cuisineRegion.present) {
      map['cuisine_region'] = Variable<String>(cuisineRegion.value);
    }
    if (defaultPortionUnit.present) {
      map['default_portion_unit'] = Variable<String>(defaultPortionUnit.value);
    }
    if (basePortionGrams.present) {
      map['base_portion_grams'] = Variable<double>(basePortionGrams.value);
    }
    if (provenance.present) {
      map['provenance'] = Variable<String>(provenance.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodCatalogEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hindiName: $hindiName, ')
          ..write('category: $category, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fatPer100g: $fatPer100g, ')
          ..write('fiberPer100g: $fiberPer100g, ')
          ..write('isVegetarian: $isVegetarian, ')
          ..write('isEgg: $isEgg, ')
          ..write('isVegan: $isVegan, ')
          ..write('cuisineRegion: $cuisineRegion, ')
          ..write('defaultPortionUnit: $defaultPortionUnit, ')
          ..write('basePortionGrams: $basePortionGrams, ')
          ..write('provenance: $provenance, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CookingMultipliersTableTable extends CookingMultipliersTable
    with TableInfo<$CookingMultipliersTableTable, CookingMultipliersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CookingMultipliersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodCategoryMeta = const VerificationMeta(
    'foodCategory',
  );
  @override
  late final GeneratedColumn<String> foodCategory = GeneratedColumn<String>(
    'food_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yieldFactorMeta = const VerificationMeta(
    'yieldFactor',
  );
  @override
  late final GeneratedColumn<double> yieldFactor = GeneratedColumn<double>(
    'yield_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waterAbsorptionPctMeta =
      const VerificationMeta('waterAbsorptionPct');
  @override
  late final GeneratedColumn<double> waterAbsorptionPct =
      GeneratedColumn<double>(
        'water_absorption_pct',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    foodCategory,
    yieldFactor,
    waterAbsorptionPct,
    version,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cooking_multipliers_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CookingMultipliersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('food_category')) {
      context.handle(
        _foodCategoryMeta,
        foodCategory.isAcceptableOrUnknown(
          data['food_category']!,
          _foodCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodCategoryMeta);
    }
    if (data.containsKey('yield_factor')) {
      context.handle(
        _yieldFactorMeta,
        yieldFactor.isAcceptableOrUnknown(
          data['yield_factor']!,
          _yieldFactorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_yieldFactorMeta);
    }
    if (data.containsKey('water_absorption_pct')) {
      context.handle(
        _waterAbsorptionPctMeta,
        waterAbsorptionPct.isAcceptableOrUnknown(
          data['water_absorption_pct']!,
          _waterAbsorptionPctMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CookingMultipliersTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CookingMultipliersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      foodCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_category'],
      )!,
      yieldFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}yield_factor'],
      )!,
      waterAbsorptionPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}water_absorption_pct'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $CookingMultipliersTableTable createAlias(String alias) {
    return $CookingMultipliersTableTable(attachedDatabase, alias);
  }
}

class CookingMultipliersTableData extends DataClass
    implements Insertable<CookingMultipliersTableData> {
  final String id;
  final String foodCategory;
  final double yieldFactor;
  final double waterAbsorptionPct;
  final int version;
  final String? notes;
  const CookingMultipliersTableData({
    required this.id,
    required this.foodCategory,
    required this.yieldFactor,
    required this.waterAbsorptionPct,
    required this.version,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['food_category'] = Variable<String>(foodCategory);
    map['yield_factor'] = Variable<double>(yieldFactor);
    map['water_absorption_pct'] = Variable<double>(waterAbsorptionPct);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  CookingMultipliersTableCompanion toCompanion(bool nullToAbsent) {
    return CookingMultipliersTableCompanion(
      id: Value(id),
      foodCategory: Value(foodCategory),
      yieldFactor: Value(yieldFactor),
      waterAbsorptionPct: Value(waterAbsorptionPct),
      version: Value(version),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory CookingMultipliersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CookingMultipliersTableData(
      id: serializer.fromJson<String>(json['id']),
      foodCategory: serializer.fromJson<String>(json['foodCategory']),
      yieldFactor: serializer.fromJson<double>(json['yieldFactor']),
      waterAbsorptionPct: serializer.fromJson<double>(
        json['waterAbsorptionPct'],
      ),
      version: serializer.fromJson<int>(json['version']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'foodCategory': serializer.toJson<String>(foodCategory),
      'yieldFactor': serializer.toJson<double>(yieldFactor),
      'waterAbsorptionPct': serializer.toJson<double>(waterAbsorptionPct),
      'version': serializer.toJson<int>(version),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  CookingMultipliersTableData copyWith({
    String? id,
    String? foodCategory,
    double? yieldFactor,
    double? waterAbsorptionPct,
    int? version,
    Value<String?> notes = const Value.absent(),
  }) => CookingMultipliersTableData(
    id: id ?? this.id,
    foodCategory: foodCategory ?? this.foodCategory,
    yieldFactor: yieldFactor ?? this.yieldFactor,
    waterAbsorptionPct: waterAbsorptionPct ?? this.waterAbsorptionPct,
    version: version ?? this.version,
    notes: notes.present ? notes.value : this.notes,
  );
  CookingMultipliersTableData copyWithCompanion(
    CookingMultipliersTableCompanion data,
  ) {
    return CookingMultipliersTableData(
      id: data.id.present ? data.id.value : this.id,
      foodCategory: data.foodCategory.present
          ? data.foodCategory.value
          : this.foodCategory,
      yieldFactor: data.yieldFactor.present
          ? data.yieldFactor.value
          : this.yieldFactor,
      waterAbsorptionPct: data.waterAbsorptionPct.present
          ? data.waterAbsorptionPct.value
          : this.waterAbsorptionPct,
      version: data.version.present ? data.version.value : this.version,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CookingMultipliersTableData(')
          ..write('id: $id, ')
          ..write('foodCategory: $foodCategory, ')
          ..write('yieldFactor: $yieldFactor, ')
          ..write('waterAbsorptionPct: $waterAbsorptionPct, ')
          ..write('version: $version, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    foodCategory,
    yieldFactor,
    waterAbsorptionPct,
    version,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CookingMultipliersTableData &&
          other.id == this.id &&
          other.foodCategory == this.foodCategory &&
          other.yieldFactor == this.yieldFactor &&
          other.waterAbsorptionPct == this.waterAbsorptionPct &&
          other.version == this.version &&
          other.notes == this.notes);
}

class CookingMultipliersTableCompanion
    extends UpdateCompanion<CookingMultipliersTableData> {
  final Value<String> id;
  final Value<String> foodCategory;
  final Value<double> yieldFactor;
  final Value<double> waterAbsorptionPct;
  final Value<int> version;
  final Value<String?> notes;
  final Value<int> rowid;
  const CookingMultipliersTableCompanion({
    this.id = const Value.absent(),
    this.foodCategory = const Value.absent(),
    this.yieldFactor = const Value.absent(),
    this.waterAbsorptionPct = const Value.absent(),
    this.version = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CookingMultipliersTableCompanion.insert({
    required String id,
    required String foodCategory,
    required double yieldFactor,
    this.waterAbsorptionPct = const Value.absent(),
    this.version = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       foodCategory = Value(foodCategory),
       yieldFactor = Value(yieldFactor);
  static Insertable<CookingMultipliersTableData> custom({
    Expression<String>? id,
    Expression<String>? foodCategory,
    Expression<double>? yieldFactor,
    Expression<double>? waterAbsorptionPct,
    Expression<int>? version,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodCategory != null) 'food_category': foodCategory,
      if (yieldFactor != null) 'yield_factor': yieldFactor,
      if (waterAbsorptionPct != null)
        'water_absorption_pct': waterAbsorptionPct,
      if (version != null) 'version': version,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CookingMultipliersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? foodCategory,
    Value<double>? yieldFactor,
    Value<double>? waterAbsorptionPct,
    Value<int>? version,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return CookingMultipliersTableCompanion(
      id: id ?? this.id,
      foodCategory: foodCategory ?? this.foodCategory,
      yieldFactor: yieldFactor ?? this.yieldFactor,
      waterAbsorptionPct: waterAbsorptionPct ?? this.waterAbsorptionPct,
      version: version ?? this.version,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (foodCategory.present) {
      map['food_category'] = Variable<String>(foodCategory.value);
    }
    if (yieldFactor.present) {
      map['yield_factor'] = Variable<double>(yieldFactor.value);
    }
    if (waterAbsorptionPct.present) {
      map['water_absorption_pct'] = Variable<double>(waterAbsorptionPct.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CookingMultipliersTableCompanion(')
          ..write('id: $id, ')
          ..write('foodCategory: $foodCategory, ')
          ..write('yieldFactor: $yieldFactor, ')
          ..write('waterAbsorptionPct: $waterAbsorptionPct, ')
          ..write('version: $version, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealLogsTableTable extends MealLogsTable
    with TableInfo<$MealLogsTableTable, MealLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealSlotMeta = const VerificationMeta(
    'mealSlot',
  );
  @override
  late final GeneratedColumn<String> mealSlot = GeneratedColumn<String>(
    'meal_slot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
    'food_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portionQuantityMeta = const VerificationMeta(
    'portionQuantity',
  );
  @override
  late final GeneratedColumn<double> portionQuantity = GeneratedColumn<double>(
    'portion_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portionUnitMeta = const VerificationMeta(
    'portionUnit',
  );
  @override
  late final GeneratedColumn<String> portionUnit = GeneratedColumn<String>(
    'portion_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cookingStateMeta = const VerificationMeta(
    'cookingState',
  );
  @override
  late final GeneratedColumn<String> cookingState = GeneratedColumn<String>(
    'cooking_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cooked'),
  );
  static const VerificationMeta _tadkaLevelMeta = const VerificationMeta(
    'tadkaLevel',
  );
  @override
  late final GeneratedColumn<String> tadkaLevel = GeneratedColumn<String>(
    'tadka_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _tadkaFatSourceMeta = const VerificationMeta(
    'tadkaFatSource',
  );
  @override
  late final GeneratedColumn<String> tadkaFatSource = GeneratedColumn<String>(
    'tadka_fat_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('oil'),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinGramsMeta = const VerificationMeta(
    'proteinGrams',
  );
  @override
  late final GeneratedColumn<double> proteinGrams = GeneratedColumn<double>(
    'protein_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsGramsMeta = const VerificationMeta(
    'carbsGrams',
  );
  @override
  late final GeneratedColumn<double> carbsGrams = GeneratedColumn<double>(
    'carbs_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatGramsMeta = const VerificationMeta(
    'fatGrams',
  );
  @override
  late final GeneratedColumn<double> fatGrams = GeneratedColumn<double>(
    'fat_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberGramsMeta = const VerificationMeta(
    'fiberGrams',
  );
  @override
  late final GeneratedColumn<double> fiberGrams = GeneratedColumn<double>(
    'fiber_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    loggedAt,
    mealSlot,
    foodName,
    portionQuantity,
    portionUnit,
    cookingState,
    tadkaLevel,
    tadkaFatSource,
    calories,
    proteinGrams,
    carbsGrams,
    fatGrams,
    fiberGrams,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealLogsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('meal_slot')) {
      context.handle(
        _mealSlotMeta,
        mealSlot.isAcceptableOrUnknown(data['meal_slot']!, _mealSlotMeta),
      );
    } else if (isInserting) {
      context.missing(_mealSlotMeta);
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('portion_quantity')) {
      context.handle(
        _portionQuantityMeta,
        portionQuantity.isAcceptableOrUnknown(
          data['portion_quantity']!,
          _portionQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_portionQuantityMeta);
    }
    if (data.containsKey('portion_unit')) {
      context.handle(
        _portionUnitMeta,
        portionUnit.isAcceptableOrUnknown(
          data['portion_unit']!,
          _portionUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_portionUnitMeta);
    }
    if (data.containsKey('cooking_state')) {
      context.handle(
        _cookingStateMeta,
        cookingState.isAcceptableOrUnknown(
          data['cooking_state']!,
          _cookingStateMeta,
        ),
      );
    }
    if (data.containsKey('tadka_level')) {
      context.handle(
        _tadkaLevelMeta,
        tadkaLevel.isAcceptableOrUnknown(data['tadka_level']!, _tadkaLevelMeta),
      );
    }
    if (data.containsKey('tadka_fat_source')) {
      context.handle(
        _tadkaFatSourceMeta,
        tadkaFatSource.isAcceptableOrUnknown(
          data['tadka_fat_source']!,
          _tadkaFatSourceMeta,
        ),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein_grams')) {
      context.handle(
        _proteinGramsMeta,
        proteinGrams.isAcceptableOrUnknown(
          data['protein_grams']!,
          _proteinGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinGramsMeta);
    }
    if (data.containsKey('carbs_grams')) {
      context.handle(
        _carbsGramsMeta,
        carbsGrams.isAcceptableOrUnknown(data['carbs_grams']!, _carbsGramsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsGramsMeta);
    }
    if (data.containsKey('fat_grams')) {
      context.handle(
        _fatGramsMeta,
        fatGrams.isAcceptableOrUnknown(data['fat_grams']!, _fatGramsMeta),
      );
    } else if (isInserting) {
      context.missing(_fatGramsMeta);
    }
    if (data.containsKey('fiber_grams')) {
      context.handle(
        _fiberGramsMeta,
        fiberGrams.isAcceptableOrUnknown(data['fiber_grams']!, _fiberGramsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealLogsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      mealSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_slot'],
      )!,
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
      )!,
      portionQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}portion_quantity'],
      )!,
      portionUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}portion_unit'],
      )!,
      cookingState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cooking_state'],
      )!,
      tadkaLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tadka_level'],
      )!,
      tadkaFatSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tadka_fat_source'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      proteinGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_grams'],
      )!,
      carbsGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_grams'],
      )!,
      fatGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_grams'],
      )!,
      fiberGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_grams'],
      )!,
    );
  }

  @override
  $MealLogsTableTable createAlias(String alias) {
    return $MealLogsTableTable(attachedDatabase, alias);
  }
}

class MealLogsTableData extends DataClass
    implements Insertable<MealLogsTableData> {
  final String id;
  final String userId;
  final DateTime loggedAt;
  final String mealSlot;
  final String foodName;
  final double portionQuantity;
  final String portionUnit;
  final String cookingState;
  final String tadkaLevel;
  final String tadkaFatSource;
  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double fiberGrams;
  const MealLogsTableData({
    required this.id,
    required this.userId,
    required this.loggedAt,
    required this.mealSlot,
    required this.foodName,
    required this.portionQuantity,
    required this.portionUnit,
    required this.cookingState,
    required this.tadkaLevel,
    required this.tadkaFatSource,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.fiberGrams,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['meal_slot'] = Variable<String>(mealSlot);
    map['food_name'] = Variable<String>(foodName);
    map['portion_quantity'] = Variable<double>(portionQuantity);
    map['portion_unit'] = Variable<String>(portionUnit);
    map['cooking_state'] = Variable<String>(cookingState);
    map['tadka_level'] = Variable<String>(tadkaLevel);
    map['tadka_fat_source'] = Variable<String>(tadkaFatSource);
    map['calories'] = Variable<double>(calories);
    map['protein_grams'] = Variable<double>(proteinGrams);
    map['carbs_grams'] = Variable<double>(carbsGrams);
    map['fat_grams'] = Variable<double>(fatGrams);
    map['fiber_grams'] = Variable<double>(fiberGrams);
    return map;
  }

  MealLogsTableCompanion toCompanion(bool nullToAbsent) {
    return MealLogsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      loggedAt: Value(loggedAt),
      mealSlot: Value(mealSlot),
      foodName: Value(foodName),
      portionQuantity: Value(portionQuantity),
      portionUnit: Value(portionUnit),
      cookingState: Value(cookingState),
      tadkaLevel: Value(tadkaLevel),
      tadkaFatSource: Value(tadkaFatSource),
      calories: Value(calories),
      proteinGrams: Value(proteinGrams),
      carbsGrams: Value(carbsGrams),
      fatGrams: Value(fatGrams),
      fiberGrams: Value(fiberGrams),
    );
  }

  factory MealLogsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealLogsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      mealSlot: serializer.fromJson<String>(json['mealSlot']),
      foodName: serializer.fromJson<String>(json['foodName']),
      portionQuantity: serializer.fromJson<double>(json['portionQuantity']),
      portionUnit: serializer.fromJson<String>(json['portionUnit']),
      cookingState: serializer.fromJson<String>(json['cookingState']),
      tadkaLevel: serializer.fromJson<String>(json['tadkaLevel']),
      tadkaFatSource: serializer.fromJson<String>(json['tadkaFatSource']),
      calories: serializer.fromJson<double>(json['calories']),
      proteinGrams: serializer.fromJson<double>(json['proteinGrams']),
      carbsGrams: serializer.fromJson<double>(json['carbsGrams']),
      fatGrams: serializer.fromJson<double>(json['fatGrams']),
      fiberGrams: serializer.fromJson<double>(json['fiberGrams']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'mealSlot': serializer.toJson<String>(mealSlot),
      'foodName': serializer.toJson<String>(foodName),
      'portionQuantity': serializer.toJson<double>(portionQuantity),
      'portionUnit': serializer.toJson<String>(portionUnit),
      'cookingState': serializer.toJson<String>(cookingState),
      'tadkaLevel': serializer.toJson<String>(tadkaLevel),
      'tadkaFatSource': serializer.toJson<String>(tadkaFatSource),
      'calories': serializer.toJson<double>(calories),
      'proteinGrams': serializer.toJson<double>(proteinGrams),
      'carbsGrams': serializer.toJson<double>(carbsGrams),
      'fatGrams': serializer.toJson<double>(fatGrams),
      'fiberGrams': serializer.toJson<double>(fiberGrams),
    };
  }

  MealLogsTableData copyWith({
    String? id,
    String? userId,
    DateTime? loggedAt,
    String? mealSlot,
    String? foodName,
    double? portionQuantity,
    String? portionUnit,
    String? cookingState,
    String? tadkaLevel,
    String? tadkaFatSource,
    double? calories,
    double? proteinGrams,
    double? carbsGrams,
    double? fatGrams,
    double? fiberGrams,
  }) => MealLogsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    loggedAt: loggedAt ?? this.loggedAt,
    mealSlot: mealSlot ?? this.mealSlot,
    foodName: foodName ?? this.foodName,
    portionQuantity: portionQuantity ?? this.portionQuantity,
    portionUnit: portionUnit ?? this.portionUnit,
    cookingState: cookingState ?? this.cookingState,
    tadkaLevel: tadkaLevel ?? this.tadkaLevel,
    tadkaFatSource: tadkaFatSource ?? this.tadkaFatSource,
    calories: calories ?? this.calories,
    proteinGrams: proteinGrams ?? this.proteinGrams,
    carbsGrams: carbsGrams ?? this.carbsGrams,
    fatGrams: fatGrams ?? this.fatGrams,
    fiberGrams: fiberGrams ?? this.fiberGrams,
  );
  MealLogsTableData copyWithCompanion(MealLogsTableCompanion data) {
    return MealLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      mealSlot: data.mealSlot.present ? data.mealSlot.value : this.mealSlot,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      portionQuantity: data.portionQuantity.present
          ? data.portionQuantity.value
          : this.portionQuantity,
      portionUnit: data.portionUnit.present
          ? data.portionUnit.value
          : this.portionUnit,
      cookingState: data.cookingState.present
          ? data.cookingState.value
          : this.cookingState,
      tadkaLevel: data.tadkaLevel.present
          ? data.tadkaLevel.value
          : this.tadkaLevel,
      tadkaFatSource: data.tadkaFatSource.present
          ? data.tadkaFatSource.value
          : this.tadkaFatSource,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinGrams: data.proteinGrams.present
          ? data.proteinGrams.value
          : this.proteinGrams,
      carbsGrams: data.carbsGrams.present
          ? data.carbsGrams.value
          : this.carbsGrams,
      fatGrams: data.fatGrams.present ? data.fatGrams.value : this.fatGrams,
      fiberGrams: data.fiberGrams.present
          ? data.fiberGrams.value
          : this.fiberGrams,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealLogsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('foodName: $foodName, ')
          ..write('portionQuantity: $portionQuantity, ')
          ..write('portionUnit: $portionUnit, ')
          ..write('cookingState: $cookingState, ')
          ..write('tadkaLevel: $tadkaLevel, ')
          ..write('tadkaFatSource: $tadkaFatSource, ')
          ..write('calories: $calories, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('fiberGrams: $fiberGrams')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    loggedAt,
    mealSlot,
    foodName,
    portionQuantity,
    portionUnit,
    cookingState,
    tadkaLevel,
    tadkaFatSource,
    calories,
    proteinGrams,
    carbsGrams,
    fatGrams,
    fiberGrams,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealLogsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.loggedAt == this.loggedAt &&
          other.mealSlot == this.mealSlot &&
          other.foodName == this.foodName &&
          other.portionQuantity == this.portionQuantity &&
          other.portionUnit == this.portionUnit &&
          other.cookingState == this.cookingState &&
          other.tadkaLevel == this.tadkaLevel &&
          other.tadkaFatSource == this.tadkaFatSource &&
          other.calories == this.calories &&
          other.proteinGrams == this.proteinGrams &&
          other.carbsGrams == this.carbsGrams &&
          other.fatGrams == this.fatGrams &&
          other.fiberGrams == this.fiberGrams);
}

class MealLogsTableCompanion extends UpdateCompanion<MealLogsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> loggedAt;
  final Value<String> mealSlot;
  final Value<String> foodName;
  final Value<double> portionQuantity;
  final Value<String> portionUnit;
  final Value<String> cookingState;
  final Value<String> tadkaLevel;
  final Value<String> tadkaFatSource;
  final Value<double> calories;
  final Value<double> proteinGrams;
  final Value<double> carbsGrams;
  final Value<double> fatGrams;
  final Value<double> fiberGrams;
  final Value<int> rowid;
  const MealLogsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.mealSlot = const Value.absent(),
    this.foodName = const Value.absent(),
    this.portionQuantity = const Value.absent(),
    this.portionUnit = const Value.absent(),
    this.cookingState = const Value.absent(),
    this.tadkaLevel = const Value.absent(),
    this.tadkaFatSource = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.fiberGrams = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealLogsTableCompanion.insert({
    required String id,
    required String userId,
    required DateTime loggedAt,
    required String mealSlot,
    required String foodName,
    required double portionQuantity,
    required String portionUnit,
    this.cookingState = const Value.absent(),
    this.tadkaLevel = const Value.absent(),
    this.tadkaFatSource = const Value.absent(),
    required double calories,
    required double proteinGrams,
    required double carbsGrams,
    required double fatGrams,
    this.fiberGrams = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       loggedAt = Value(loggedAt),
       mealSlot = Value(mealSlot),
       foodName = Value(foodName),
       portionQuantity = Value(portionQuantity),
       portionUnit = Value(portionUnit),
       calories = Value(calories),
       proteinGrams = Value(proteinGrams),
       carbsGrams = Value(carbsGrams),
       fatGrams = Value(fatGrams);
  static Insertable<MealLogsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? loggedAt,
    Expression<String>? mealSlot,
    Expression<String>? foodName,
    Expression<double>? portionQuantity,
    Expression<String>? portionUnit,
    Expression<String>? cookingState,
    Expression<String>? tadkaLevel,
    Expression<String>? tadkaFatSource,
    Expression<double>? calories,
    Expression<double>? proteinGrams,
    Expression<double>? carbsGrams,
    Expression<double>? fatGrams,
    Expression<double>? fiberGrams,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (mealSlot != null) 'meal_slot': mealSlot,
      if (foodName != null) 'food_name': foodName,
      if (portionQuantity != null) 'portion_quantity': portionQuantity,
      if (portionUnit != null) 'portion_unit': portionUnit,
      if (cookingState != null) 'cooking_state': cookingState,
      if (tadkaLevel != null) 'tadka_level': tadkaLevel,
      if (tadkaFatSource != null) 'tadka_fat_source': tadkaFatSource,
      if (calories != null) 'calories': calories,
      if (proteinGrams != null) 'protein_grams': proteinGrams,
      if (carbsGrams != null) 'carbs_grams': carbsGrams,
      if (fatGrams != null) 'fat_grams': fatGrams,
      if (fiberGrams != null) 'fiber_grams': fiberGrams,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealLogsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? loggedAt,
    Value<String>? mealSlot,
    Value<String>? foodName,
    Value<double>? portionQuantity,
    Value<String>? portionUnit,
    Value<String>? cookingState,
    Value<String>? tadkaLevel,
    Value<String>? tadkaFatSource,
    Value<double>? calories,
    Value<double>? proteinGrams,
    Value<double>? carbsGrams,
    Value<double>? fatGrams,
    Value<double>? fiberGrams,
    Value<int>? rowid,
  }) {
    return MealLogsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      loggedAt: loggedAt ?? this.loggedAt,
      mealSlot: mealSlot ?? this.mealSlot,
      foodName: foodName ?? this.foodName,
      portionQuantity: portionQuantity ?? this.portionQuantity,
      portionUnit: portionUnit ?? this.portionUnit,
      cookingState: cookingState ?? this.cookingState,
      tadkaLevel: tadkaLevel ?? this.tadkaLevel,
      tadkaFatSource: tadkaFatSource ?? this.tadkaFatSource,
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      fiberGrams: fiberGrams ?? this.fiberGrams,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (mealSlot.present) {
      map['meal_slot'] = Variable<String>(mealSlot.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (portionQuantity.present) {
      map['portion_quantity'] = Variable<double>(portionQuantity.value);
    }
    if (portionUnit.present) {
      map['portion_unit'] = Variable<String>(portionUnit.value);
    }
    if (cookingState.present) {
      map['cooking_state'] = Variable<String>(cookingState.value);
    }
    if (tadkaLevel.present) {
      map['tadka_level'] = Variable<String>(tadkaLevel.value);
    }
    if (tadkaFatSource.present) {
      map['tadka_fat_source'] = Variable<String>(tadkaFatSource.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (proteinGrams.present) {
      map['protein_grams'] = Variable<double>(proteinGrams.value);
    }
    if (carbsGrams.present) {
      map['carbs_grams'] = Variable<double>(carbsGrams.value);
    }
    if (fatGrams.present) {
      map['fat_grams'] = Variable<double>(fatGrams.value);
    }
    if (fiberGrams.present) {
      map['fiber_grams'] = Variable<double>(fiberGrams.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('foodName: $foodName, ')
          ..write('portionQuantity: $portionQuantity, ')
          ..write('portionUnit: $portionUnit, ')
          ..write('cookingState: $cookingState, ')
          ..write('tadkaLevel: $tadkaLevel, ')
          ..write('tadkaFatSource: $tadkaFatSource, ')
          ..write('calories: $calories, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('fiberGrams: $fiberGrams, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTableTable extends RecipesTable
    with TableInfo<$RecipesTableTable, RecipesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientsJsonMeta = const VerificationMeta(
    'ingredientsJson',
  );
  @override
  late final GeneratedColumn<String> ingredientsJson = GeneratedColumn<String>(
    'ingredients_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalYieldGramsOrKatorisMeta =
      const VerificationMeta('totalYieldGramsOrKatoris');
  @override
  late final GeneratedColumn<double> totalYieldGramsOrKatoris =
      GeneratedColumn<double>(
        'total_yield_grams_or_katoris',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _totalCaloriesMeta = const VerificationMeta(
    'totalCalories',
  );
  @override
  late final GeneratedColumn<double> totalCalories = GeneratedColumn<double>(
    'total_calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalProteinMeta = const VerificationMeta(
    'totalProtein',
  );
  @override
  late final GeneratedColumn<double> totalProtein = GeneratedColumn<double>(
    'total_protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCarbsMeta = const VerificationMeta(
    'totalCarbs',
  );
  @override
  late final GeneratedColumn<double> totalCarbs = GeneratedColumn<double>(
    'total_carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalFatMeta = const VerificationMeta(
    'totalFat',
  );
  @override
  late final GeneratedColumn<double> totalFat = GeneratedColumn<double>(
    'total_fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalFiberMeta = const VerificationMeta(
    'totalFiber',
  );
  @override
  late final GeneratedColumn<double> totalFiber = GeneratedColumn<double>(
    'total_fiber',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    ingredientsJson,
    totalYieldGramsOrKatoris,
    totalCalories,
    totalProtein,
    totalCarbs,
    totalFat,
    totalFiber,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ingredients_json')) {
      context.handle(
        _ingredientsJsonMeta,
        ingredientsJson.isAcceptableOrUnknown(
          data['ingredients_json']!,
          _ingredientsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientsJsonMeta);
    }
    if (data.containsKey('total_yield_grams_or_katoris')) {
      context.handle(
        _totalYieldGramsOrKatorisMeta,
        totalYieldGramsOrKatoris.isAcceptableOrUnknown(
          data['total_yield_grams_or_katoris']!,
          _totalYieldGramsOrKatorisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalYieldGramsOrKatorisMeta);
    }
    if (data.containsKey('total_calories')) {
      context.handle(
        _totalCaloriesMeta,
        totalCalories.isAcceptableOrUnknown(
          data['total_calories']!,
          _totalCaloriesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCaloriesMeta);
    }
    if (data.containsKey('total_protein')) {
      context.handle(
        _totalProteinMeta,
        totalProtein.isAcceptableOrUnknown(
          data['total_protein']!,
          _totalProteinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalProteinMeta);
    }
    if (data.containsKey('total_carbs')) {
      context.handle(
        _totalCarbsMeta,
        totalCarbs.isAcceptableOrUnknown(data['total_carbs']!, _totalCarbsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCarbsMeta);
    }
    if (data.containsKey('total_fat')) {
      context.handle(
        _totalFatMeta,
        totalFat.isAcceptableOrUnknown(data['total_fat']!, _totalFatMeta),
      );
    } else if (isInserting) {
      context.missing(_totalFatMeta);
    }
    if (data.containsKey('total_fiber')) {
      context.handle(
        _totalFiberMeta,
        totalFiber.isAcceptableOrUnknown(data['total_fiber']!, _totalFiberMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ingredientsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredients_json'],
      )!,
      totalYieldGramsOrKatoris: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_yield_grams_or_katoris'],
      )!,
      totalCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_calories'],
      )!,
      totalProtein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_protein'],
      )!,
      totalCarbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_carbs'],
      )!,
      totalFat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_fat'],
      )!,
      totalFiber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_fiber'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecipesTableTable createAlias(String alias) {
    return $RecipesTableTable(attachedDatabase, alias);
  }
}

class RecipesTableData extends DataClass
    implements Insertable<RecipesTableData> {
  final String id;
  final String userId;
  final String name;
  final String ingredientsJson;
  final double totalYieldGramsOrKatoris;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double totalFiber;
  final DateTime createdAt;
  const RecipesTableData({
    required this.id,
    required this.userId,
    required this.name,
    required this.ingredientsJson,
    required this.totalYieldGramsOrKatoris,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.totalFiber,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['ingredients_json'] = Variable<String>(ingredientsJson);
    map['total_yield_grams_or_katoris'] = Variable<double>(
      totalYieldGramsOrKatoris,
    );
    map['total_calories'] = Variable<double>(totalCalories);
    map['total_protein'] = Variable<double>(totalProtein);
    map['total_carbs'] = Variable<double>(totalCarbs);
    map['total_fat'] = Variable<double>(totalFat);
    map['total_fiber'] = Variable<double>(totalFiber);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecipesTableCompanion toCompanion(bool nullToAbsent) {
    return RecipesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      ingredientsJson: Value(ingredientsJson),
      totalYieldGramsOrKatoris: Value(totalYieldGramsOrKatoris),
      totalCalories: Value(totalCalories),
      totalProtein: Value(totalProtein),
      totalCarbs: Value(totalCarbs),
      totalFat: Value(totalFat),
      totalFiber: Value(totalFiber),
      createdAt: Value(createdAt),
    );
  }

  factory RecipesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipesTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      ingredientsJson: serializer.fromJson<String>(json['ingredientsJson']),
      totalYieldGramsOrKatoris: serializer.fromJson<double>(
        json['totalYieldGramsOrKatoris'],
      ),
      totalCalories: serializer.fromJson<double>(json['totalCalories']),
      totalProtein: serializer.fromJson<double>(json['totalProtein']),
      totalCarbs: serializer.fromJson<double>(json['totalCarbs']),
      totalFat: serializer.fromJson<double>(json['totalFat']),
      totalFiber: serializer.fromJson<double>(json['totalFiber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'ingredientsJson': serializer.toJson<String>(ingredientsJson),
      'totalYieldGramsOrKatoris': serializer.toJson<double>(
        totalYieldGramsOrKatoris,
      ),
      'totalCalories': serializer.toJson<double>(totalCalories),
      'totalProtein': serializer.toJson<double>(totalProtein),
      'totalCarbs': serializer.toJson<double>(totalCarbs),
      'totalFat': serializer.toJson<double>(totalFat),
      'totalFiber': serializer.toJson<double>(totalFiber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecipesTableData copyWith({
    String? id,
    String? userId,
    String? name,
    String? ingredientsJson,
    double? totalYieldGramsOrKatoris,
    double? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    double? totalFiber,
    DateTime? createdAt,
  }) => RecipesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    ingredientsJson: ingredientsJson ?? this.ingredientsJson,
    totalYieldGramsOrKatoris:
        totalYieldGramsOrKatoris ?? this.totalYieldGramsOrKatoris,
    totalCalories: totalCalories ?? this.totalCalories,
    totalProtein: totalProtein ?? this.totalProtein,
    totalCarbs: totalCarbs ?? this.totalCarbs,
    totalFat: totalFat ?? this.totalFat,
    totalFiber: totalFiber ?? this.totalFiber,
    createdAt: createdAt ?? this.createdAt,
  );
  RecipesTableData copyWithCompanion(RecipesTableCompanion data) {
    return RecipesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      ingredientsJson: data.ingredientsJson.present
          ? data.ingredientsJson.value
          : this.ingredientsJson,
      totalYieldGramsOrKatoris: data.totalYieldGramsOrKatoris.present
          ? data.totalYieldGramsOrKatoris.value
          : this.totalYieldGramsOrKatoris,
      totalCalories: data.totalCalories.present
          ? data.totalCalories.value
          : this.totalCalories,
      totalProtein: data.totalProtein.present
          ? data.totalProtein.value
          : this.totalProtein,
      totalCarbs: data.totalCarbs.present
          ? data.totalCarbs.value
          : this.totalCarbs,
      totalFat: data.totalFat.present ? data.totalFat.value : this.totalFat,
      totalFiber: data.totalFiber.present
          ? data.totalFiber.value
          : this.totalFiber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('totalYieldGramsOrKatoris: $totalYieldGramsOrKatoris, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalProtein: $totalProtein, ')
          ..write('totalCarbs: $totalCarbs, ')
          ..write('totalFat: $totalFat, ')
          ..write('totalFiber: $totalFiber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    ingredientsJson,
    totalYieldGramsOrKatoris,
    totalCalories,
    totalProtein,
    totalCarbs,
    totalFat,
    totalFiber,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.ingredientsJson == this.ingredientsJson &&
          other.totalYieldGramsOrKatoris == this.totalYieldGramsOrKatoris &&
          other.totalCalories == this.totalCalories &&
          other.totalProtein == this.totalProtein &&
          other.totalCarbs == this.totalCarbs &&
          other.totalFat == this.totalFat &&
          other.totalFiber == this.totalFiber &&
          other.createdAt == this.createdAt);
}

class RecipesTableCompanion extends UpdateCompanion<RecipesTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> ingredientsJson;
  final Value<double> totalYieldGramsOrKatoris;
  final Value<double> totalCalories;
  final Value<double> totalProtein;
  final Value<double> totalCarbs;
  final Value<double> totalFat;
  final Value<double> totalFiber;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RecipesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.ingredientsJson = const Value.absent(),
    this.totalYieldGramsOrKatoris = const Value.absent(),
    this.totalCalories = const Value.absent(),
    this.totalProtein = const Value.absent(),
    this.totalCarbs = const Value.absent(),
    this.totalFat = const Value.absent(),
    this.totalFiber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesTableCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String ingredientsJson,
    required double totalYieldGramsOrKatoris,
    required double totalCalories,
    required double totalProtein,
    required double totalCarbs,
    required double totalFat,
    this.totalFiber = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       ingredientsJson = Value(ingredientsJson),
       totalYieldGramsOrKatoris = Value(totalYieldGramsOrKatoris),
       totalCalories = Value(totalCalories),
       totalProtein = Value(totalProtein),
       totalCarbs = Value(totalCarbs),
       totalFat = Value(totalFat),
       createdAt = Value(createdAt);
  static Insertable<RecipesTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? ingredientsJson,
    Expression<double>? totalYieldGramsOrKatoris,
    Expression<double>? totalCalories,
    Expression<double>? totalProtein,
    Expression<double>? totalCarbs,
    Expression<double>? totalFat,
    Expression<double>? totalFiber,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (ingredientsJson != null) 'ingredients_json': ingredientsJson,
      if (totalYieldGramsOrKatoris != null)
        'total_yield_grams_or_katoris': totalYieldGramsOrKatoris,
      if (totalCalories != null) 'total_calories': totalCalories,
      if (totalProtein != null) 'total_protein': totalProtein,
      if (totalCarbs != null) 'total_carbs': totalCarbs,
      if (totalFat != null) 'total_fat': totalFat,
      if (totalFiber != null) 'total_fiber': totalFiber,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<String>? ingredientsJson,
    Value<double>? totalYieldGramsOrKatoris,
    Value<double>? totalCalories,
    Value<double>? totalProtein,
    Value<double>? totalCarbs,
    Value<double>? totalFat,
    Value<double>? totalFiber,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RecipesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      ingredientsJson: ingredientsJson ?? this.ingredientsJson,
      totalYieldGramsOrKatoris:
          totalYieldGramsOrKatoris ?? this.totalYieldGramsOrKatoris,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      totalFiber: totalFiber ?? this.totalFiber,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ingredientsJson.present) {
      map['ingredients_json'] = Variable<String>(ingredientsJson.value);
    }
    if (totalYieldGramsOrKatoris.present) {
      map['total_yield_grams_or_katoris'] = Variable<double>(
        totalYieldGramsOrKatoris.value,
      );
    }
    if (totalCalories.present) {
      map['total_calories'] = Variable<double>(totalCalories.value);
    }
    if (totalProtein.present) {
      map['total_protein'] = Variable<double>(totalProtein.value);
    }
    if (totalCarbs.present) {
      map['total_carbs'] = Variable<double>(totalCarbs.value);
    }
    if (totalFat.present) {
      map['total_fat'] = Variable<double>(totalFat.value);
    }
    if (totalFiber.present) {
      map['total_fiber'] = Variable<double>(totalFiber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('totalYieldGramsOrKatoris: $totalYieldGramsOrKatoris, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalProtein: $totalProtein, ')
          ..write('totalCarbs: $totalCarbs, ')
          ..write('totalFat: $totalFat, ')
          ..write('totalFiber: $totalFiber, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OutboxMutationsTable outboxMutations = $OutboxMutationsTable(
    this,
  );
  late final $LocalUserProfilesTable localUserProfiles =
      $LocalUserProfilesTable(this);
  late final $BodyMetricEntriesTableTable bodyMetricEntriesTable =
      $BodyMetricEntriesTableTable(this);
  late final $StepRecordsTableTable stepRecordsTable = $StepRecordsTableTable(
    this,
  );
  late final $SleepRecordsTableTable sleepRecordsTable =
      $SleepRecordsTableTable(this);
  late final $WaterLogsTableTable waterLogsTable = $WaterLogsTableTable(this);
  late final $MoodLogsTableTable moodLogsTable = $MoodLogsTableTable(this);
  late final $VitalRecordsTableTable vitalRecordsTable =
      $VitalRecordsTableTable(this);
  late final $MedicationEntriesTableTable medicationEntriesTable =
      $MedicationEntriesTableTable(this);
  late final $HabitEntriesTableTable habitEntriesTable =
      $HabitEntriesTableTable(this);
  late final $FoodCatalogEntriesTableTable foodCatalogEntriesTable =
      $FoodCatalogEntriesTableTable(this);
  late final $CookingMultipliersTableTable cookingMultipliersTable =
      $CookingMultipliersTableTable(this);
  late final $MealLogsTableTable mealLogsTable = $MealLogsTableTable(this);
  late final $RecipesTableTable recipesTable = $RecipesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    outboxMutations,
    localUserProfiles,
    bodyMetricEntriesTable,
    stepRecordsTable,
    sleepRecordsTable,
    waterLogsTable,
    moodLogsTable,
    vitalRecordsTable,
    medicationEntriesTable,
    habitEntriesTable,
    foodCatalogEntriesTable,
    cookingMultipliersTable,
    mealLogsTable,
    recipesTable,
  ];
}

typedef $$OutboxMutationsTableCreateCompanionBuilder =
    OutboxMutationsCompanion Function({
      required String id,
      required String entityType,
      required String operationType,
      required String payloadJson,
      required String idempotencyKey,
      required DateTime createdAt,
      Value<int> retryCount,
      Value<String> status,
      Value<String?> lastError,
      Value<String?> dependencyId,
      Value<int> rowid,
    });
typedef $$OutboxMutationsTableUpdateCompanionBuilder =
    OutboxMutationsCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> operationType,
      Value<String> payloadJson,
      Value<String> idempotencyKey,
      Value<DateTime> createdAt,
      Value<int> retryCount,
      Value<String> status,
      Value<String?> lastError,
      Value<String?> dependencyId,
      Value<int> rowid,
    });

class $$OutboxMutationsTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxMutationsTable> {
  $$OutboxMutationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dependencyId => $composableBuilder(
    column: $table.dependencyId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxMutationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxMutationsTable> {
  $$OutboxMutationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dependencyId => $composableBuilder(
    column: $table.dependencyId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxMutationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxMutationsTable> {
  $$OutboxMutationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get dependencyId => $composableBuilder(
    column: $table.dependencyId,
    builder: (column) => column,
  );
}

class $$OutboxMutationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxMutationsTable,
          OutboxMutation,
          $$OutboxMutationsTableFilterComposer,
          $$OutboxMutationsTableOrderingComposer,
          $$OutboxMutationsTableAnnotationComposer,
          $$OutboxMutationsTableCreateCompanionBuilder,
          $$OutboxMutationsTableUpdateCompanionBuilder,
          (
            OutboxMutation,
            BaseReferences<
              _$AppDatabase,
              $OutboxMutationsTable,
              OutboxMutation
            >,
          ),
          OutboxMutation,
          PrefetchHooks Function()
        > {
  $$OutboxMutationsTableTableManager(
    _$AppDatabase db,
    $OutboxMutationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxMutationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxMutationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxMutationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> dependencyId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxMutationsCompanion(
                id: id,
                entityType: entityType,
                operationType: operationType,
                payloadJson: payloadJson,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                retryCount: retryCount,
                status: status,
                lastError: lastError,
                dependencyId: dependencyId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String operationType,
                required String payloadJson,
                required String idempotencyKey,
                required DateTime createdAt,
                Value<int> retryCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> dependencyId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxMutationsCompanion.insert(
                id: id,
                entityType: entityType,
                operationType: operationType,
                payloadJson: payloadJson,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                retryCount: retryCount,
                status: status,
                lastError: lastError,
                dependencyId: dependencyId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxMutationsTable, OutboxMutation>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OutboxMutationsTable,
                    OutboxMutation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxMutationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxMutationsTable,
      OutboxMutation,
      $$OutboxMutationsTableFilterComposer,
      $$OutboxMutationsTableOrderingComposer,
      $$OutboxMutationsTableAnnotationComposer,
      $$OutboxMutationsTableCreateCompanionBuilder,
      $$OutboxMutationsTableUpdateCompanionBuilder,
      (
        OutboxMutation,
        BaseReferences<_$AppDatabase, $OutboxMutationsTable, OutboxMutation>,
      ),
      OutboxMutation,
      PrefetchHooks Function()
    >;
typedef $$LocalUserProfilesTableCreateCompanionBuilder =
    LocalUserProfilesCompanion Function({
      required String userId,
      required String displayName,
      required int age,
      required String biologicalSex,
      required double heightCm,
      required double weightKg,
      Value<double?> targetWeightKg,
      required String activityLevel,
      required String dietaryIdentity,
      required String healthGoal,
      Value<String> languageCode,
      Value<String?> doshaProfileJson,
      Value<bool> hasAcceptedDpdpConsent,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalUserProfilesTableUpdateCompanionBuilder =
    LocalUserProfilesCompanion Function({
      Value<String> userId,
      Value<String> displayName,
      Value<int> age,
      Value<String> biologicalSex,
      Value<double> heightCm,
      Value<double> weightKg,
      Value<double?> targetWeightKg,
      Value<String> activityLevel,
      Value<String> dietaryIdentity,
      Value<String> healthGoal,
      Value<String> languageCode,
      Value<String?> doshaProfileJson,
      Value<bool> hasAcceptedDpdpConsent,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalUserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUserProfilesTable> {
  $$LocalUserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get biologicalSex => $composableBuilder(
    column: $table.biologicalSex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietaryIdentity => $composableBuilder(
    column: $table.dietaryIdentity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get healthGoal => $composableBuilder(
    column: $table.healthGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doshaProfileJson => $composableBuilder(
    column: $table.doshaProfileJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAcceptedDpdpConsent => $composableBuilder(
    column: $table.hasAcceptedDpdpConsent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUserProfilesTable> {
  $$LocalUserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get biologicalSex => $composableBuilder(
    column: $table.biologicalSex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietaryIdentity => $composableBuilder(
    column: $table.dietaryIdentity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthGoal => $composableBuilder(
    column: $table.healthGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doshaProfileJson => $composableBuilder(
    column: $table.doshaProfileJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAcceptedDpdpConsent => $composableBuilder(
    column: $table.hasAcceptedDpdpConsent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUserProfilesTable> {
  $$LocalUserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get biologicalSex => $composableBuilder(
    column: $table.biologicalSex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietaryIdentity => $composableBuilder(
    column: $table.dietaryIdentity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get healthGoal => $composableBuilder(
    column: $table.healthGoal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doshaProfileJson => $composableBuilder(
    column: $table.doshaProfileJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasAcceptedDpdpConsent => $composableBuilder(
    column: $table.hasAcceptedDpdpConsent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalUserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUserProfilesTable,
          LocalUserProfile,
          $$LocalUserProfilesTableFilterComposer,
          $$LocalUserProfilesTableOrderingComposer,
          $$LocalUserProfilesTableAnnotationComposer,
          $$LocalUserProfilesTableCreateCompanionBuilder,
          $$LocalUserProfilesTableUpdateCompanionBuilder,
          (
            LocalUserProfile,
            BaseReferences<
              _$AppDatabase,
              $LocalUserProfilesTable,
              LocalUserProfile
            >,
          ),
          LocalUserProfile,
          PrefetchHooks Function()
        > {
  $$LocalUserProfilesTableTableManager(
    _$AppDatabase db,
    $LocalUserProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUserProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<String> biologicalSex = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double?> targetWeightKg = const Value.absent(),
                Value<String> activityLevel = const Value.absent(),
                Value<String> dietaryIdentity = const Value.absent(),
                Value<String> healthGoal = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String?> doshaProfileJson = const Value.absent(),
                Value<bool> hasAcceptedDpdpConsent = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserProfilesCompanion(
                userId: userId,
                displayName: displayName,
                age: age,
                biologicalSex: biologicalSex,
                heightCm: heightCm,
                weightKg: weightKg,
                targetWeightKg: targetWeightKg,
                activityLevel: activityLevel,
                dietaryIdentity: dietaryIdentity,
                healthGoal: healthGoal,
                languageCode: languageCode,
                doshaProfileJson: doshaProfileJson,
                hasAcceptedDpdpConsent: hasAcceptedDpdpConsent,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String displayName,
                required int age,
                required String biologicalSex,
                required double heightCm,
                required double weightKg,
                Value<double?> targetWeightKg = const Value.absent(),
                required String activityLevel,
                required String dietaryIdentity,
                required String healthGoal,
                Value<String> languageCode = const Value.absent(),
                Value<String?> doshaProfileJson = const Value.absent(),
                Value<bool> hasAcceptedDpdpConsent = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalUserProfilesCompanion.insert(
                userId: userId,
                displayName: displayName,
                age: age,
                biologicalSex: biologicalSex,
                heightCm: heightCm,
                weightKg: weightKg,
                targetWeightKg: targetWeightKg,
                activityLevel: activityLevel,
                dietaryIdentity: dietaryIdentity,
                healthGoal: healthGoal,
                languageCode: languageCode,
                doshaProfileJson: doshaProfileJson,
                hasAcceptedDpdpConsent: hasAcceptedDpdpConsent,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalUserProfilesTable, LocalUserProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalUserProfilesTable,
                    LocalUserProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUserProfilesTable,
      LocalUserProfile,
      $$LocalUserProfilesTableFilterComposer,
      $$LocalUserProfilesTableOrderingComposer,
      $$LocalUserProfilesTableAnnotationComposer,
      $$LocalUserProfilesTableCreateCompanionBuilder,
      $$LocalUserProfilesTableUpdateCompanionBuilder,
      (
        LocalUserProfile,
        BaseReferences<
          _$AppDatabase,
          $LocalUserProfilesTable,
          LocalUserProfile
        >,
      ),
      LocalUserProfile,
      PrefetchHooks Function()
    >;
typedef $$BodyMetricEntriesTableTableCreateCompanionBuilder =
    BodyMetricEntriesTableCompanion Function({
      required String id,
      required String userId,
      required String metricType,
      required double value,
      required String unit,
      required DateTime recordedAt,
      Value<String> source,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$BodyMetricEntriesTableTableUpdateCompanionBuilder =
    BodyMetricEntriesTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> metricType,
      Value<double> value,
      Value<String> unit,
      Value<DateTime> recordedAt,
      Value<String> source,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$BodyMetricEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BodyMetricEntriesTableTable> {
  $$BodyMetricEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyMetricEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyMetricEntriesTableTable> {
  $$BodyMetricEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyMetricEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyMetricEntriesTableTable> {
  $$BodyMetricEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$BodyMetricEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyMetricEntriesTableTable,
          BodyMetricEntriesTableData,
          $$BodyMetricEntriesTableTableFilterComposer,
          $$BodyMetricEntriesTableTableOrderingComposer,
          $$BodyMetricEntriesTableTableAnnotationComposer,
          $$BodyMetricEntriesTableTableCreateCompanionBuilder,
          $$BodyMetricEntriesTableTableUpdateCompanionBuilder,
          (
            BodyMetricEntriesTableData,
            BaseReferences<
              _$AppDatabase,
              $BodyMetricEntriesTableTable,
              BodyMetricEntriesTableData
            >,
          ),
          BodyMetricEntriesTableData,
          PrefetchHooks Function()
        > {
  $$BodyMetricEntriesTableTableTableManager(
    _$AppDatabase db,
    $BodyMetricEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyMetricEntriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BodyMetricEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BodyMetricEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> metricType = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyMetricEntriesTableCompanion(
                id: id,
                userId: userId,
                metricType: metricType,
                value: value,
                unit: unit,
                recordedAt: recordedAt,
                source: source,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String metricType,
                required double value,
                required String unit,
                required DateTime recordedAt,
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyMetricEntriesTableCompanion.insert(
                id: id,
                userId: userId,
                metricType: metricType,
                value: value,
                unit: unit,
                recordedAt: recordedAt,
                source: source,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $BodyMetricEntriesTableTable,
                    BodyMetricEntriesTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BodyMetricEntriesTableTable,
                    BodyMetricEntriesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyMetricEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyMetricEntriesTableTable,
      BodyMetricEntriesTableData,
      $$BodyMetricEntriesTableTableFilterComposer,
      $$BodyMetricEntriesTableTableOrderingComposer,
      $$BodyMetricEntriesTableTableAnnotationComposer,
      $$BodyMetricEntriesTableTableCreateCompanionBuilder,
      $$BodyMetricEntriesTableTableUpdateCompanionBuilder,
      (
        BodyMetricEntriesTableData,
        BaseReferences<
          _$AppDatabase,
          $BodyMetricEntriesTableTable,
          BodyMetricEntriesTableData
        >,
      ),
      BodyMetricEntriesTableData,
      PrefetchHooks Function()
    >;
typedef $$StepRecordsTableTableCreateCompanionBuilder =
    StepRecordsTableCompanion Function({
      required String id,
      required String userId,
      required DateTime date,
      required int stepCount,
      Value<int> goal,
      Value<String> source,
      Value<int> rowid,
    });
typedef $$StepRecordsTableTableUpdateCompanionBuilder =
    StepRecordsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> date,
      Value<int> stepCount,
      Value<int> goal,
      Value<String> source,
      Value<int> rowid,
    });

class $$StepRecordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $StepRecordsTableTable> {
  $$StepRecordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stepCount => $composableBuilder(
    column: $table.stepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StepRecordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StepRecordsTableTable> {
  $$StepRecordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stepCount => $composableBuilder(
    column: $table.stepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StepRecordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StepRecordsTableTable> {
  $$StepRecordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get stepCount =>
      $composableBuilder(column: $table.stepCount, builder: (column) => column);

  GeneratedColumn<int> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$StepRecordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StepRecordsTableTable,
          StepRecordsTableData,
          $$StepRecordsTableTableFilterComposer,
          $$StepRecordsTableTableOrderingComposer,
          $$StepRecordsTableTableAnnotationComposer,
          $$StepRecordsTableTableCreateCompanionBuilder,
          $$StepRecordsTableTableUpdateCompanionBuilder,
          (
            StepRecordsTableData,
            BaseReferences<
              _$AppDatabase,
              $StepRecordsTableTable,
              StepRecordsTableData
            >,
          ),
          StepRecordsTableData,
          PrefetchHooks Function()
        > {
  $$StepRecordsTableTableTableManager(
    _$AppDatabase db,
    $StepRecordsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StepRecordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StepRecordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StepRecordsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> stepCount = const Value.absent(),
                Value<int> goal = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StepRecordsTableCompanion(
                id: id,
                userId: userId,
                date: date,
                stepCount: stepCount,
                goal: goal,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime date,
                required int stepCount,
                Value<int> goal = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StepRecordsTableCompanion.insert(
                id: id,
                userId: userId,
                date: date,
                stepCount: stepCount,
                goal: goal,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StepRecordsTableTable, StepRecordsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $StepRecordsTableTable,
                    StepRecordsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StepRecordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StepRecordsTableTable,
      StepRecordsTableData,
      $$StepRecordsTableTableFilterComposer,
      $$StepRecordsTableTableOrderingComposer,
      $$StepRecordsTableTableAnnotationComposer,
      $$StepRecordsTableTableCreateCompanionBuilder,
      $$StepRecordsTableTableUpdateCompanionBuilder,
      (
        StepRecordsTableData,
        BaseReferences<
          _$AppDatabase,
          $StepRecordsTableTable,
          StepRecordsTableData
        >,
      ),
      StepRecordsTableData,
      PrefetchHooks Function()
    >;
typedef $$SleepRecordsTableTableCreateCompanionBuilder =
    SleepRecordsTableCompanion Function({
      required String id,
      required String userId,
      required DateTime startTime,
      required DateTime endTime,
      required int durationMinutes,
      Value<int> qualityRating,
      Value<int?> deepSleepMinutes,
      Value<int?> remSleepMinutes,
      Value<String> source,
      Value<int> rowid,
    });
typedef $$SleepRecordsTableTableUpdateCompanionBuilder =
    SleepRecordsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<int> durationMinutes,
      Value<int> qualityRating,
      Value<int?> deepSleepMinutes,
      Value<int?> remSleepMinutes,
      Value<String> source,
      Value<int> rowid,
    });

class $$SleepRecordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SleepRecordsTableTable> {
  $$SleepRecordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deepSleepMinutes => $composableBuilder(
    column: $table.deepSleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remSleepMinutes => $composableBuilder(
    column: $table.remSleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepRecordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepRecordsTableTable> {
  $$SleepRecordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deepSleepMinutes => $composableBuilder(
    column: $table.deepSleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remSleepMinutes => $composableBuilder(
    column: $table.remSleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepRecordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepRecordsTableTable> {
  $$SleepRecordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deepSleepMinutes => $composableBuilder(
    column: $table.deepSleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remSleepMinutes => $composableBuilder(
    column: $table.remSleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$SleepRecordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepRecordsTableTable,
          SleepRecordsTableData,
          $$SleepRecordsTableTableFilterComposer,
          $$SleepRecordsTableTableOrderingComposer,
          $$SleepRecordsTableTableAnnotationComposer,
          $$SleepRecordsTableTableCreateCompanionBuilder,
          $$SleepRecordsTableTableUpdateCompanionBuilder,
          (
            SleepRecordsTableData,
            BaseReferences<
              _$AppDatabase,
              $SleepRecordsTableTable,
              SleepRecordsTableData
            >,
          ),
          SleepRecordsTableData,
          PrefetchHooks Function()
        > {
  $$SleepRecordsTableTableTableManager(
    _$AppDatabase db,
    $SleepRecordsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepRecordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepRecordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepRecordsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> qualityRating = const Value.absent(),
                Value<int?> deepSleepMinutes = const Value.absent(),
                Value<int?> remSleepMinutes = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepRecordsTableCompanion(
                id: id,
                userId: userId,
                startTime: startTime,
                endTime: endTime,
                durationMinutes: durationMinutes,
                qualityRating: qualityRating,
                deepSleepMinutes: deepSleepMinutes,
                remSleepMinutes: remSleepMinutes,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime startTime,
                required DateTime endTime,
                required int durationMinutes,
                Value<int> qualityRating = const Value.absent(),
                Value<int?> deepSleepMinutes = const Value.absent(),
                Value<int?> remSleepMinutes = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepRecordsTableCompanion.insert(
                id: id,
                userId: userId,
                startTime: startTime,
                endTime: endTime,
                durationMinutes: durationMinutes,
                qualityRating: qualityRating,
                deepSleepMinutes: deepSleepMinutes,
                remSleepMinutes: remSleepMinutes,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SleepRecordsTableTable, SleepRecordsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $SleepRecordsTableTable,
                    SleepRecordsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepRecordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepRecordsTableTable,
      SleepRecordsTableData,
      $$SleepRecordsTableTableFilterComposer,
      $$SleepRecordsTableTableOrderingComposer,
      $$SleepRecordsTableTableAnnotationComposer,
      $$SleepRecordsTableTableCreateCompanionBuilder,
      $$SleepRecordsTableTableUpdateCompanionBuilder,
      (
        SleepRecordsTableData,
        BaseReferences<
          _$AppDatabase,
          $SleepRecordsTableTable,
          SleepRecordsTableData
        >,
      ),
      SleepRecordsTableData,
      PrefetchHooks Function()
    >;
typedef $$WaterLogsTableTableCreateCompanionBuilder =
    WaterLogsTableCompanion Function({
      required String id,
      required String userId,
      required DateTime recordedAt,
      required int amountMl,
      Value<int> dailyGoalMl,
      Value<int> rowid,
    });
typedef $$WaterLogsTableTableUpdateCompanionBuilder =
    WaterLogsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> recordedAt,
      Value<int> amountMl,
      Value<int> dailyGoalMl,
      Value<int> rowid,
    });

class $$WaterLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WaterLogsTableTable> {
  $$WaterLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoalMl => $composableBuilder(
    column: $table.dailyGoalMl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaterLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterLogsTableTable> {
  $$WaterLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoalMl => $composableBuilder(
    column: $table.dailyGoalMl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaterLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterLogsTableTable> {
  $$WaterLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<int> get dailyGoalMl => $composableBuilder(
    column: $table.dailyGoalMl,
    builder: (column) => column,
  );
}

class $$WaterLogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterLogsTableTable,
          WaterLogsTableData,
          $$WaterLogsTableTableFilterComposer,
          $$WaterLogsTableTableOrderingComposer,
          $$WaterLogsTableTableAnnotationComposer,
          $$WaterLogsTableTableCreateCompanionBuilder,
          $$WaterLogsTableTableUpdateCompanionBuilder,
          (
            WaterLogsTableData,
            BaseReferences<
              _$AppDatabase,
              $WaterLogsTableTable,
              WaterLogsTableData
            >,
          ),
          WaterLogsTableData,
          PrefetchHooks Function()
        > {
  $$WaterLogsTableTableTableManager(
    _$AppDatabase db,
    $WaterLogsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> amountMl = const Value.absent(),
                Value<int> dailyGoalMl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WaterLogsTableCompanion(
                id: id,
                userId: userId,
                recordedAt: recordedAt,
                amountMl: amountMl,
                dailyGoalMl: dailyGoalMl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime recordedAt,
                required int amountMl,
                Value<int> dailyGoalMl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WaterLogsTableCompanion.insert(
                id: id,
                userId: userId,
                recordedAt: recordedAt,
                amountMl: amountMl,
                dailyGoalMl: dailyGoalMl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WaterLogsTableTable, WaterLogsTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WaterLogsTableTable,
                    WaterLogsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaterLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterLogsTableTable,
      WaterLogsTableData,
      $$WaterLogsTableTableFilterComposer,
      $$WaterLogsTableTableOrderingComposer,
      $$WaterLogsTableTableAnnotationComposer,
      $$WaterLogsTableTableCreateCompanionBuilder,
      $$WaterLogsTableTableUpdateCompanionBuilder,
      (
        WaterLogsTableData,
        BaseReferences<_$AppDatabase, $WaterLogsTableTable, WaterLogsTableData>,
      ),
      WaterLogsTableData,
      PrefetchHooks Function()
    >;
typedef $$MoodLogsTableTableCreateCompanionBuilder =
    MoodLogsTableCompanion Function({
      required String id,
      required String userId,
      required DateTime recordedAt,
      required int moodScore,
      Value<String?> notes,
      Value<String?> tagsJson,
      Value<int> rowid,
    });
typedef $$MoodLogsTableTableUpdateCompanionBuilder =
    MoodLogsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> recordedAt,
      Value<int> moodScore,
      Value<String?> notes,
      Value<String?> tagsJson,
      Value<int> rowid,
    });

class $$MoodLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MoodLogsTableTable> {
  $$MoodLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodLogsTableTable> {
  $$MoodLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodLogsTableTable> {
  $$MoodLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get moodScore =>
      $composableBuilder(column: $table.moodScore, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);
}

class $$MoodLogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodLogsTableTable,
          MoodLogsTableData,
          $$MoodLogsTableTableFilterComposer,
          $$MoodLogsTableTableOrderingComposer,
          $$MoodLogsTableTableAnnotationComposer,
          $$MoodLogsTableTableCreateCompanionBuilder,
          $$MoodLogsTableTableUpdateCompanionBuilder,
          (
            MoodLogsTableData,
            BaseReferences<
              _$AppDatabase,
              $MoodLogsTableTable,
              MoodLogsTableData
            >,
          ),
          MoodLogsTableData,
          PrefetchHooks Function()
        > {
  $$MoodLogsTableTableTableManager(_$AppDatabase db, $MoodLogsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> moodScore = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tagsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodLogsTableCompanion(
                id: id,
                userId: userId,
                recordedAt: recordedAt,
                moodScore: moodScore,
                notes: notes,
                tagsJson: tagsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime recordedAt,
                required int moodScore,
                Value<String?> notes = const Value.absent(),
                Value<String?> tagsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodLogsTableCompanion.insert(
                id: id,
                userId: userId,
                recordedAt: recordedAt,
                moodScore: moodScore,
                notes: notes,
                tagsJson: tagsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoodLogsTableTable, MoodLogsTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MoodLogsTableTable,
                    MoodLogsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoodLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodLogsTableTable,
      MoodLogsTableData,
      $$MoodLogsTableTableFilterComposer,
      $$MoodLogsTableTableOrderingComposer,
      $$MoodLogsTableTableAnnotationComposer,
      $$MoodLogsTableTableCreateCompanionBuilder,
      $$MoodLogsTableTableUpdateCompanionBuilder,
      (
        MoodLogsTableData,
        BaseReferences<_$AppDatabase, $MoodLogsTableTable, MoodLogsTableData>,
      ),
      MoodLogsTableData,
      PrefetchHooks Function()
    >;
typedef $$VitalRecordsTableTableCreateCompanionBuilder =
    VitalRecordsTableCompanion Function({
      required String id,
      required String userId,
      required DateTime recordedAt,
      required String vitalType,
      Value<int?> systolic,
      Value<int?> diastolic,
      Value<int?> pulse,
      Value<double?> glucoseMgDl,
      Value<String?> contextTag,
      Value<String> source,
      Value<int> rowid,
    });
typedef $$VitalRecordsTableTableUpdateCompanionBuilder =
    VitalRecordsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> recordedAt,
      Value<String> vitalType,
      Value<int?> systolic,
      Value<int?> diastolic,
      Value<int?> pulse,
      Value<double?> glucoseMgDl,
      Value<String?> contextTag,
      Value<String> source,
      Value<int> rowid,
    });

class $$VitalRecordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $VitalRecordsTableTable> {
  $$VitalRecordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vitalType => $composableBuilder(
    column: $table.vitalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pulse => $composableBuilder(
    column: $table.pulse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get glucoseMgDl => $composableBuilder(
    column: $table.glucoseMgDl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextTag => $composableBuilder(
    column: $table.contextTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VitalRecordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VitalRecordsTableTable> {
  $$VitalRecordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vitalType => $composableBuilder(
    column: $table.vitalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pulse => $composableBuilder(
    column: $table.pulse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get glucoseMgDl => $composableBuilder(
    column: $table.glucoseMgDl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextTag => $composableBuilder(
    column: $table.contextTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VitalRecordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VitalRecordsTableTable> {
  $$VitalRecordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vitalType =>
      $composableBuilder(column: $table.vitalType, builder: (column) => column);

  GeneratedColumn<int> get systolic =>
      $composableBuilder(column: $table.systolic, builder: (column) => column);

  GeneratedColumn<int> get diastolic =>
      $composableBuilder(column: $table.diastolic, builder: (column) => column);

  GeneratedColumn<int> get pulse =>
      $composableBuilder(column: $table.pulse, builder: (column) => column);

  GeneratedColumn<double> get glucoseMgDl => $composableBuilder(
    column: $table.glucoseMgDl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextTag => $composableBuilder(
    column: $table.contextTag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$VitalRecordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VitalRecordsTableTable,
          VitalRecordsTableData,
          $$VitalRecordsTableTableFilterComposer,
          $$VitalRecordsTableTableOrderingComposer,
          $$VitalRecordsTableTableAnnotationComposer,
          $$VitalRecordsTableTableCreateCompanionBuilder,
          $$VitalRecordsTableTableUpdateCompanionBuilder,
          (
            VitalRecordsTableData,
            BaseReferences<
              _$AppDatabase,
              $VitalRecordsTableTable,
              VitalRecordsTableData
            >,
          ),
          VitalRecordsTableData,
          PrefetchHooks Function()
        > {
  $$VitalRecordsTableTableTableManager(
    _$AppDatabase db,
    $VitalRecordsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VitalRecordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VitalRecordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VitalRecordsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> vitalType = const Value.absent(),
                Value<int?> systolic = const Value.absent(),
                Value<int?> diastolic = const Value.absent(),
                Value<int?> pulse = const Value.absent(),
                Value<double?> glucoseMgDl = const Value.absent(),
                Value<String?> contextTag = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VitalRecordsTableCompanion(
                id: id,
                userId: userId,
                recordedAt: recordedAt,
                vitalType: vitalType,
                systolic: systolic,
                diastolic: diastolic,
                pulse: pulse,
                glucoseMgDl: glucoseMgDl,
                contextTag: contextTag,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime recordedAt,
                required String vitalType,
                Value<int?> systolic = const Value.absent(),
                Value<int?> diastolic = const Value.absent(),
                Value<int?> pulse = const Value.absent(),
                Value<double?> glucoseMgDl = const Value.absent(),
                Value<String?> contextTag = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VitalRecordsTableCompanion.insert(
                id: id,
                userId: userId,
                recordedAt: recordedAt,
                vitalType: vitalType,
                systolic: systolic,
                diastolic: diastolic,
                pulse: pulse,
                glucoseMgDl: glucoseMgDl,
                contextTag: contextTag,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VitalRecordsTableTable, VitalRecordsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $VitalRecordsTableTable,
                    VitalRecordsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VitalRecordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VitalRecordsTableTable,
      VitalRecordsTableData,
      $$VitalRecordsTableTableFilterComposer,
      $$VitalRecordsTableTableOrderingComposer,
      $$VitalRecordsTableTableAnnotationComposer,
      $$VitalRecordsTableTableCreateCompanionBuilder,
      $$VitalRecordsTableTableUpdateCompanionBuilder,
      (
        VitalRecordsTableData,
        BaseReferences<
          _$AppDatabase,
          $VitalRecordsTableTable,
          VitalRecordsTableData
        >,
      ),
      VitalRecordsTableData,
      PrefetchHooks Function()
    >;
typedef $$MedicationEntriesTableTableCreateCompanionBuilder =
    MedicationEntriesTableCompanion Function({
      required String id,
      required String userId,
      required String name,
      required String dosage,
      required String timeOfDay,
      Value<String> status,
      required DateTime scheduledDate,
      Value<int> rowid,
    });
typedef $$MedicationEntriesTableTableUpdateCompanionBuilder =
    MedicationEntriesTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<String> dosage,
      Value<String> timeOfDay,
      Value<String> status,
      Value<DateTime> scheduledDate,
      Value<int> rowid,
    });

class $$MedicationEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationEntriesTableTable> {
  $$MedicationEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicationEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationEntriesTableTable> {
  $$MedicationEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationEntriesTableTable> {
  $$MedicationEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get timeOfDay =>
      $composableBuilder(column: $table.timeOfDay, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );
}

class $$MedicationEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationEntriesTableTable,
          MedicationEntriesTableData,
          $$MedicationEntriesTableTableFilterComposer,
          $$MedicationEntriesTableTableOrderingComposer,
          $$MedicationEntriesTableTableAnnotationComposer,
          $$MedicationEntriesTableTableCreateCompanionBuilder,
          $$MedicationEntriesTableTableUpdateCompanionBuilder,
          (
            MedicationEntriesTableData,
            BaseReferences<
              _$AppDatabase,
              $MedicationEntriesTableTable,
              MedicationEntriesTableData
            >,
          ),
          MedicationEntriesTableData,
          PrefetchHooks Function()
        > {
  $$MedicationEntriesTableTableTableManager(
    _$AppDatabase db,
    $MedicationEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationEntriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MedicationEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MedicationEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> dosage = const Value.absent(),
                Value<String> timeOfDay = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> scheduledDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationEntriesTableCompanion(
                id: id,
                userId: userId,
                name: name,
                dosage: dosage,
                timeOfDay: timeOfDay,
                status: status,
                scheduledDate: scheduledDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required String dosage,
                required String timeOfDay,
                Value<String> status = const Value.absent(),
                required DateTime scheduledDate,
                Value<int> rowid = const Value.absent(),
              }) => MedicationEntriesTableCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                dosage: dosage,
                timeOfDay: timeOfDay,
                status: status,
                scheduledDate: scheduledDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $MedicationEntriesTableTable,
                    MedicationEntriesTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MedicationEntriesTableTable,
                    MedicationEntriesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicationEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationEntriesTableTable,
      MedicationEntriesTableData,
      $$MedicationEntriesTableTableFilterComposer,
      $$MedicationEntriesTableTableOrderingComposer,
      $$MedicationEntriesTableTableAnnotationComposer,
      $$MedicationEntriesTableTableCreateCompanionBuilder,
      $$MedicationEntriesTableTableUpdateCompanionBuilder,
      (
        MedicationEntriesTableData,
        BaseReferences<
          _$AppDatabase,
          $MedicationEntriesTableTable,
          MedicationEntriesTableData
        >,
      ),
      MedicationEntriesTableData,
      PrefetchHooks Function()
    >;
typedef $$HabitEntriesTableTableCreateCompanionBuilder =
    HabitEntriesTableCompanion Function({
      required String id,
      required String userId,
      required String title,
      Value<String> frequency,
      Value<int> targetDays,
      Value<int> currentStreak,
      Value<int> bestStreak,
      Value<DateTime?> lastCompletedAt,
      Value<int> rowid,
    });
typedef $$HabitEntriesTableTableUpdateCompanionBuilder =
    HabitEntriesTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> title,
      Value<String> frequency,
      Value<int> targetDays,
      Value<int> currentStreak,
      Value<int> bestStreak,
      Value<DateTime?> lastCompletedAt,
      Value<int> rowid,
    });

class $$HabitEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $HabitEntriesTableTable> {
  $$HabitEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDays => $composableBuilder(
    column: $table.targetDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCompletedAt => $composableBuilder(
    column: $table.lastCompletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitEntriesTableTable> {
  $$HabitEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDays => $composableBuilder(
    column: $table.targetDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCompletedAt => $composableBuilder(
    column: $table.lastCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitEntriesTableTable> {
  $$HabitEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get targetDays => $composableBuilder(
    column: $table.targetDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCompletedAt => $composableBuilder(
    column: $table.lastCompletedAt,
    builder: (column) => column,
  );
}

class $$HabitEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitEntriesTableTable,
          HabitEntriesTableData,
          $$HabitEntriesTableTableFilterComposer,
          $$HabitEntriesTableTableOrderingComposer,
          $$HabitEntriesTableTableAnnotationComposer,
          $$HabitEntriesTableTableCreateCompanionBuilder,
          $$HabitEntriesTableTableUpdateCompanionBuilder,
          (
            HabitEntriesTableData,
            BaseReferences<
              _$AppDatabase,
              $HabitEntriesTableTable,
              HabitEntriesTableData
            >,
          ),
          HabitEntriesTableData,
          PrefetchHooks Function()
        > {
  $$HabitEntriesTableTableTableManager(
    _$AppDatabase db,
    $HabitEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitEntriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitEntriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> targetDays = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<DateTime?> lastCompletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitEntriesTableCompanion(
                id: id,
                userId: userId,
                title: title,
                frequency: frequency,
                targetDays: targetDays,
                currentStreak: currentStreak,
                bestStreak: bestStreak,
                lastCompletedAt: lastCompletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String title,
                Value<String> frequency = const Value.absent(),
                Value<int> targetDays = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<DateTime?> lastCompletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitEntriesTableCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                frequency: frequency,
                targetDays: targetDays,
                currentStreak: currentStreak,
                bestStreak: bestStreak,
                lastCompletedAt: lastCompletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitEntriesTableTable, HabitEntriesTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $HabitEntriesTableTable,
                    HabitEntriesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitEntriesTableTable,
      HabitEntriesTableData,
      $$HabitEntriesTableTableFilterComposer,
      $$HabitEntriesTableTableOrderingComposer,
      $$HabitEntriesTableTableAnnotationComposer,
      $$HabitEntriesTableTableCreateCompanionBuilder,
      $$HabitEntriesTableTableUpdateCompanionBuilder,
      (
        HabitEntriesTableData,
        BaseReferences<
          _$AppDatabase,
          $HabitEntriesTableTable,
          HabitEntriesTableData
        >,
      ),
      HabitEntriesTableData,
      PrefetchHooks Function()
    >;
typedef $$FoodCatalogEntriesTableTableCreateCompanionBuilder =
    FoodCatalogEntriesTableCompanion Function({
      required String id,
      required String name,
      Value<String> hindiName,
      required String category,
      required double caloriesPer100g,
      required double proteinPer100g,
      required double carbsPer100g,
      required double fatPer100g,
      Value<double> fiberPer100g,
      Value<bool> isVegetarian,
      Value<bool> isEgg,
      Value<bool> isVegan,
      Value<String> cuisineRegion,
      Value<String> defaultPortionUnit,
      Value<double> basePortionGrams,
      Value<String> provenance,
      Value<int> rowid,
    });
typedef $$FoodCatalogEntriesTableTableUpdateCompanionBuilder =
    FoodCatalogEntriesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> hindiName,
      Value<String> category,
      Value<double> caloriesPer100g,
      Value<double> proteinPer100g,
      Value<double> carbsPer100g,
      Value<double> fatPer100g,
      Value<double> fiberPer100g,
      Value<bool> isVegetarian,
      Value<bool> isEgg,
      Value<bool> isVegan,
      Value<String> cuisineRegion,
      Value<String> defaultPortionUnit,
      Value<double> basePortionGrams,
      Value<String> provenance,
      Value<int> rowid,
    });

class $$FoodCatalogEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $FoodCatalogEntriesTableTable> {
  $$FoodCatalogEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hindiName => $composableBuilder(
    column: $table.hindiName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVegetarian => $composableBuilder(
    column: $table.isVegetarian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEgg => $composableBuilder(
    column: $table.isEgg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVegan => $composableBuilder(
    column: $table.isVegan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cuisineRegion => $composableBuilder(
    column: $table.cuisineRegion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultPortionUnit => $composableBuilder(
    column: $table.defaultPortionUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get basePortionGrams => $composableBuilder(
    column: $table.basePortionGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodCatalogEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodCatalogEntriesTableTable> {
  $$FoodCatalogEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hindiName => $composableBuilder(
    column: $table.hindiName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVegetarian => $composableBuilder(
    column: $table.isVegetarian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEgg => $composableBuilder(
    column: $table.isEgg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVegan => $composableBuilder(
    column: $table.isVegan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuisineRegion => $composableBuilder(
    column: $table.cuisineRegion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultPortionUnit => $composableBuilder(
    column: $table.defaultPortionUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get basePortionGrams => $composableBuilder(
    column: $table.basePortionGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodCatalogEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodCatalogEntriesTableTable> {
  $$FoodCatalogEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get hindiName =>
      $composableBuilder(column: $table.hindiName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVegetarian => $composableBuilder(
    column: $table.isVegetarian,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEgg =>
      $composableBuilder(column: $table.isEgg, builder: (column) => column);

  GeneratedColumn<bool> get isVegan =>
      $composableBuilder(column: $table.isVegan, builder: (column) => column);

  GeneratedColumn<String> get cuisineRegion => $composableBuilder(
    column: $table.cuisineRegion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultPortionUnit => $composableBuilder(
    column: $table.defaultPortionUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get basePortionGrams => $composableBuilder(
    column: $table.basePortionGrams,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => column,
  );
}

class $$FoodCatalogEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodCatalogEntriesTableTable,
          FoodCatalogEntriesTableData,
          $$FoodCatalogEntriesTableTableFilterComposer,
          $$FoodCatalogEntriesTableTableOrderingComposer,
          $$FoodCatalogEntriesTableTableAnnotationComposer,
          $$FoodCatalogEntriesTableTableCreateCompanionBuilder,
          $$FoodCatalogEntriesTableTableUpdateCompanionBuilder,
          (
            FoodCatalogEntriesTableData,
            BaseReferences<
              _$AppDatabase,
              $FoodCatalogEntriesTableTable,
              FoodCatalogEntriesTableData
            >,
          ),
          FoodCatalogEntriesTableData,
          PrefetchHooks Function()
        > {
  $$FoodCatalogEntriesTableTableTableManager(
    _$AppDatabase db,
    $FoodCatalogEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodCatalogEntriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FoodCatalogEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FoodCatalogEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> hindiName = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> caloriesPer100g = const Value.absent(),
                Value<double> proteinPer100g = const Value.absent(),
                Value<double> carbsPer100g = const Value.absent(),
                Value<double> fatPer100g = const Value.absent(),
                Value<double> fiberPer100g = const Value.absent(),
                Value<bool> isVegetarian = const Value.absent(),
                Value<bool> isEgg = const Value.absent(),
                Value<bool> isVegan = const Value.absent(),
                Value<String> cuisineRegion = const Value.absent(),
                Value<String> defaultPortionUnit = const Value.absent(),
                Value<double> basePortionGrams = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodCatalogEntriesTableCompanion(
                id: id,
                name: name,
                hindiName: hindiName,
                category: category,
                caloriesPer100g: caloriesPer100g,
                proteinPer100g: proteinPer100g,
                carbsPer100g: carbsPer100g,
                fatPer100g: fatPer100g,
                fiberPer100g: fiberPer100g,
                isVegetarian: isVegetarian,
                isEgg: isEgg,
                isVegan: isVegan,
                cuisineRegion: cuisineRegion,
                defaultPortionUnit: defaultPortionUnit,
                basePortionGrams: basePortionGrams,
                provenance: provenance,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> hindiName = const Value.absent(),
                required String category,
                required double caloriesPer100g,
                required double proteinPer100g,
                required double carbsPer100g,
                required double fatPer100g,
                Value<double> fiberPer100g = const Value.absent(),
                Value<bool> isVegetarian = const Value.absent(),
                Value<bool> isEgg = const Value.absent(),
                Value<bool> isVegan = const Value.absent(),
                Value<String> cuisineRegion = const Value.absent(),
                Value<String> defaultPortionUnit = const Value.absent(),
                Value<double> basePortionGrams = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodCatalogEntriesTableCompanion.insert(
                id: id,
                name: name,
                hindiName: hindiName,
                category: category,
                caloriesPer100g: caloriesPer100g,
                proteinPer100g: proteinPer100g,
                carbsPer100g: carbsPer100g,
                fatPer100g: fatPer100g,
                fiberPer100g: fiberPer100g,
                isVegetarian: isVegetarian,
                isEgg: isEgg,
                isVegan: isVegan,
                cuisineRegion: cuisineRegion,
                defaultPortionUnit: defaultPortionUnit,
                basePortionGrams: basePortionGrams,
                provenance: provenance,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $FoodCatalogEntriesTableTable,
                    FoodCatalogEntriesTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FoodCatalogEntriesTableTable,
                    FoodCatalogEntriesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodCatalogEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodCatalogEntriesTableTable,
      FoodCatalogEntriesTableData,
      $$FoodCatalogEntriesTableTableFilterComposer,
      $$FoodCatalogEntriesTableTableOrderingComposer,
      $$FoodCatalogEntriesTableTableAnnotationComposer,
      $$FoodCatalogEntriesTableTableCreateCompanionBuilder,
      $$FoodCatalogEntriesTableTableUpdateCompanionBuilder,
      (
        FoodCatalogEntriesTableData,
        BaseReferences<
          _$AppDatabase,
          $FoodCatalogEntriesTableTable,
          FoodCatalogEntriesTableData
        >,
      ),
      FoodCatalogEntriesTableData,
      PrefetchHooks Function()
    >;
typedef $$CookingMultipliersTableTableCreateCompanionBuilder =
    CookingMultipliersTableCompanion Function({
      required String id,
      required String foodCategory,
      required double yieldFactor,
      Value<double> waterAbsorptionPct,
      Value<int> version,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$CookingMultipliersTableTableUpdateCompanionBuilder =
    CookingMultipliersTableCompanion Function({
      Value<String> id,
      Value<String> foodCategory,
      Value<double> yieldFactor,
      Value<double> waterAbsorptionPct,
      Value<int> version,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$CookingMultipliersTableTableFilterComposer
    extends Composer<_$AppDatabase, $CookingMultipliersTableTable> {
  $$CookingMultipliersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodCategory => $composableBuilder(
    column: $table.foodCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get yieldFactor => $composableBuilder(
    column: $table.yieldFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waterAbsorptionPct => $composableBuilder(
    column: $table.waterAbsorptionPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CookingMultipliersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CookingMultipliersTableTable> {
  $$CookingMultipliersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodCategory => $composableBuilder(
    column: $table.foodCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get yieldFactor => $composableBuilder(
    column: $table.yieldFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waterAbsorptionPct => $composableBuilder(
    column: $table.waterAbsorptionPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CookingMultipliersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CookingMultipliersTableTable> {
  $$CookingMultipliersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get foodCategory => $composableBuilder(
    column: $table.foodCategory,
    builder: (column) => column,
  );

  GeneratedColumn<double> get yieldFactor => $composableBuilder(
    column: $table.yieldFactor,
    builder: (column) => column,
  );

  GeneratedColumn<double> get waterAbsorptionPct => $composableBuilder(
    column: $table.waterAbsorptionPct,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$CookingMultipliersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CookingMultipliersTableTable,
          CookingMultipliersTableData,
          $$CookingMultipliersTableTableFilterComposer,
          $$CookingMultipliersTableTableOrderingComposer,
          $$CookingMultipliersTableTableAnnotationComposer,
          $$CookingMultipliersTableTableCreateCompanionBuilder,
          $$CookingMultipliersTableTableUpdateCompanionBuilder,
          (
            CookingMultipliersTableData,
            BaseReferences<
              _$AppDatabase,
              $CookingMultipliersTableTable,
              CookingMultipliersTableData
            >,
          ),
          CookingMultipliersTableData,
          PrefetchHooks Function()
        > {
  $$CookingMultipliersTableTableTableManager(
    _$AppDatabase db,
    $CookingMultipliersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CookingMultipliersTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CookingMultipliersTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CookingMultipliersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> foodCategory = const Value.absent(),
                Value<double> yieldFactor = const Value.absent(),
                Value<double> waterAbsorptionPct = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CookingMultipliersTableCompanion(
                id: id,
                foodCategory: foodCategory,
                yieldFactor: yieldFactor,
                waterAbsorptionPct: waterAbsorptionPct,
                version: version,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String foodCategory,
                required double yieldFactor,
                Value<double> waterAbsorptionPct = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CookingMultipliersTableCompanion.insert(
                id: id,
                foodCategory: foodCategory,
                yieldFactor: yieldFactor,
                waterAbsorptionPct: waterAbsorptionPct,
                version: version,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $CookingMultipliersTableTable,
                    CookingMultipliersTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CookingMultipliersTableTable,
                    CookingMultipliersTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CookingMultipliersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CookingMultipliersTableTable,
      CookingMultipliersTableData,
      $$CookingMultipliersTableTableFilterComposer,
      $$CookingMultipliersTableTableOrderingComposer,
      $$CookingMultipliersTableTableAnnotationComposer,
      $$CookingMultipliersTableTableCreateCompanionBuilder,
      $$CookingMultipliersTableTableUpdateCompanionBuilder,
      (
        CookingMultipliersTableData,
        BaseReferences<
          _$AppDatabase,
          $CookingMultipliersTableTable,
          CookingMultipliersTableData
        >,
      ),
      CookingMultipliersTableData,
      PrefetchHooks Function()
    >;
typedef $$MealLogsTableTableCreateCompanionBuilder =
    MealLogsTableCompanion Function({
      required String id,
      required String userId,
      required DateTime loggedAt,
      required String mealSlot,
      required String foodName,
      required double portionQuantity,
      required String portionUnit,
      Value<String> cookingState,
      Value<String> tadkaLevel,
      Value<String> tadkaFatSource,
      required double calories,
      required double proteinGrams,
      required double carbsGrams,
      required double fatGrams,
      Value<double> fiberGrams,
      Value<int> rowid,
    });
typedef $$MealLogsTableTableUpdateCompanionBuilder =
    MealLogsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> loggedAt,
      Value<String> mealSlot,
      Value<String> foodName,
      Value<double> portionQuantity,
      Value<String> portionUnit,
      Value<String> cookingState,
      Value<String> tadkaLevel,
      Value<String> tadkaFatSource,
      Value<double> calories,
      Value<double> proteinGrams,
      Value<double> carbsGrams,
      Value<double> fatGrams,
      Value<double> fiberGrams,
      Value<int> rowid,
    });

class $$MealLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MealLogsTableTable> {
  $$MealLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealSlot => $composableBuilder(
    column: $table.mealSlot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get portionQuantity => $composableBuilder(
    column: $table.portionQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portionUnit => $composableBuilder(
    column: $table.portionUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cookingState => $composableBuilder(
    column: $table.cookingState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tadkaLevel => $composableBuilder(
    column: $table.tadkaLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tadkaFatSource => $composableBuilder(
    column: $table.tadkaFatSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberGrams => $composableBuilder(
    column: $table.fiberGrams,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MealLogsTableTable> {
  $$MealLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealSlot => $composableBuilder(
    column: $table.mealSlot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get portionQuantity => $composableBuilder(
    column: $table.portionQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portionUnit => $composableBuilder(
    column: $table.portionUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cookingState => $composableBuilder(
    column: $table.cookingState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tadkaLevel => $composableBuilder(
    column: $table.tadkaLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tadkaFatSource => $composableBuilder(
    column: $table.tadkaFatSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberGrams => $composableBuilder(
    column: $table.fiberGrams,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealLogsTableTable> {
  $$MealLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<String> get mealSlot =>
      $composableBuilder(column: $table.mealSlot, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<double> get portionQuantity => $composableBuilder(
    column: $table.portionQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get portionUnit => $composableBuilder(
    column: $table.portionUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cookingState => $composableBuilder(
    column: $table.cookingState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tadkaLevel => $composableBuilder(
    column: $table.tadkaLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tadkaFatSource => $composableBuilder(
    column: $table.tadkaFatSource,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatGrams =>
      $composableBuilder(column: $table.fatGrams, builder: (column) => column);

  GeneratedColumn<double> get fiberGrams => $composableBuilder(
    column: $table.fiberGrams,
    builder: (column) => column,
  );
}

class $$MealLogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealLogsTableTable,
          MealLogsTableData,
          $$MealLogsTableTableFilterComposer,
          $$MealLogsTableTableOrderingComposer,
          $$MealLogsTableTableAnnotationComposer,
          $$MealLogsTableTableCreateCompanionBuilder,
          $$MealLogsTableTableUpdateCompanionBuilder,
          (
            MealLogsTableData,
            BaseReferences<
              _$AppDatabase,
              $MealLogsTableTable,
              MealLogsTableData
            >,
          ),
          MealLogsTableData,
          PrefetchHooks Function()
        > {
  $$MealLogsTableTableTableManager(_$AppDatabase db, $MealLogsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<String> mealSlot = const Value.absent(),
                Value<String> foodName = const Value.absent(),
                Value<double> portionQuantity = const Value.absent(),
                Value<String> portionUnit = const Value.absent(),
                Value<String> cookingState = const Value.absent(),
                Value<String> tadkaLevel = const Value.absent(),
                Value<String> tadkaFatSource = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> proteinGrams = const Value.absent(),
                Value<double> carbsGrams = const Value.absent(),
                Value<double> fatGrams = const Value.absent(),
                Value<double> fiberGrams = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealLogsTableCompanion(
                id: id,
                userId: userId,
                loggedAt: loggedAt,
                mealSlot: mealSlot,
                foodName: foodName,
                portionQuantity: portionQuantity,
                portionUnit: portionUnit,
                cookingState: cookingState,
                tadkaLevel: tadkaLevel,
                tadkaFatSource: tadkaFatSource,
                calories: calories,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                fiberGrams: fiberGrams,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime loggedAt,
                required String mealSlot,
                required String foodName,
                required double portionQuantity,
                required String portionUnit,
                Value<String> cookingState = const Value.absent(),
                Value<String> tadkaLevel = const Value.absent(),
                Value<String> tadkaFatSource = const Value.absent(),
                required double calories,
                required double proteinGrams,
                required double carbsGrams,
                required double fatGrams,
                Value<double> fiberGrams = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealLogsTableCompanion.insert(
                id: id,
                userId: userId,
                loggedAt: loggedAt,
                mealSlot: mealSlot,
                foodName: foodName,
                portionQuantity: portionQuantity,
                portionUnit: portionUnit,
                cookingState: cookingState,
                tadkaLevel: tadkaLevel,
                tadkaFatSource: tadkaFatSource,
                calories: calories,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                fiberGrams: fiberGrams,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealLogsTableTable, MealLogsTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MealLogsTableTable,
                    MealLogsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealLogsTableTable,
      MealLogsTableData,
      $$MealLogsTableTableFilterComposer,
      $$MealLogsTableTableOrderingComposer,
      $$MealLogsTableTableAnnotationComposer,
      $$MealLogsTableTableCreateCompanionBuilder,
      $$MealLogsTableTableUpdateCompanionBuilder,
      (
        MealLogsTableData,
        BaseReferences<_$AppDatabase, $MealLogsTableTable, MealLogsTableData>,
      ),
      MealLogsTableData,
      PrefetchHooks Function()
    >;
typedef $$RecipesTableTableCreateCompanionBuilder =
    RecipesTableCompanion Function({
      required String id,
      required String userId,
      required String name,
      required String ingredientsJson,
      required double totalYieldGramsOrKatoris,
      required double totalCalories,
      required double totalProtein,
      required double totalCarbs,
      required double totalFat,
      Value<double> totalFiber,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RecipesTableTableUpdateCompanionBuilder =
    RecipesTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<String> ingredientsJson,
      Value<double> totalYieldGramsOrKatoris,
      Value<double> totalCalories,
      Value<double> totalProtein,
      Value<double> totalCarbs,
      Value<double> totalFat,
      Value<double> totalFiber,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RecipesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalYieldGramsOrKatoris => $composableBuilder(
    column: $table.totalYieldGramsOrKatoris,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalProtein => $composableBuilder(
    column: $table.totalProtein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCarbs => $composableBuilder(
    column: $table.totalCarbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalFat => $composableBuilder(
    column: $table.totalFat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalFiber => $composableBuilder(
    column: $table.totalFiber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalYieldGramsOrKatoris => $composableBuilder(
    column: $table.totalYieldGramsOrKatoris,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalProtein => $composableBuilder(
    column: $table.totalProtein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCarbs => $composableBuilder(
    column: $table.totalCarbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalFat => $composableBuilder(
    column: $table.totalFat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalFiber => $composableBuilder(
    column: $table.totalFiber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalYieldGramsOrKatoris => $composableBuilder(
    column: $table.totalYieldGramsOrKatoris,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalProtein => $composableBuilder(
    column: $table.totalProtein,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCarbs => $composableBuilder(
    column: $table.totalCarbs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalFat =>
      $composableBuilder(column: $table.totalFat, builder: (column) => column);

  GeneratedColumn<double> get totalFiber => $composableBuilder(
    column: $table.totalFiber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecipesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTableTable,
          RecipesTableData,
          $$RecipesTableTableFilterComposer,
          $$RecipesTableTableOrderingComposer,
          $$RecipesTableTableAnnotationComposer,
          $$RecipesTableTableCreateCompanionBuilder,
          $$RecipesTableTableUpdateCompanionBuilder,
          (
            RecipesTableData,
            BaseReferences<_$AppDatabase, $RecipesTableTable, RecipesTableData>,
          ),
          RecipesTableData,
          PrefetchHooks Function()
        > {
  $$RecipesTableTableTableManager(_$AppDatabase db, $RecipesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> ingredientsJson = const Value.absent(),
                Value<double> totalYieldGramsOrKatoris = const Value.absent(),
                Value<double> totalCalories = const Value.absent(),
                Value<double> totalProtein = const Value.absent(),
                Value<double> totalCarbs = const Value.absent(),
                Value<double> totalFat = const Value.absent(),
                Value<double> totalFiber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesTableCompanion(
                id: id,
                userId: userId,
                name: name,
                ingredientsJson: ingredientsJson,
                totalYieldGramsOrKatoris: totalYieldGramsOrKatoris,
                totalCalories: totalCalories,
                totalProtein: totalProtein,
                totalCarbs: totalCarbs,
                totalFat: totalFat,
                totalFiber: totalFiber,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required String ingredientsJson,
                required double totalYieldGramsOrKatoris,
                required double totalCalories,
                required double totalProtein,
                required double totalCarbs,
                required double totalFat,
                Value<double> totalFiber = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RecipesTableCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                ingredientsJson: ingredientsJson,
                totalYieldGramsOrKatoris: totalYieldGramsOrKatoris,
                totalCalories: totalCalories,
                totalProtein: totalProtein,
                totalCarbs: totalCarbs,
                totalFat: totalFat,
                totalFiber: totalFiber,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipesTableTable, RecipesTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecipesTableTable,
                    RecipesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTableTable,
      RecipesTableData,
      $$RecipesTableTableFilterComposer,
      $$RecipesTableTableOrderingComposer,
      $$RecipesTableTableAnnotationComposer,
      $$RecipesTableTableCreateCompanionBuilder,
      $$RecipesTableTableUpdateCompanionBuilder,
      (
        RecipesTableData,
        BaseReferences<_$AppDatabase, $RecipesTableTable, RecipesTableData>,
      ),
      RecipesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OutboxMutationsTableTableManager get outboxMutations =>
      $$OutboxMutationsTableTableManager(_db, _db.outboxMutations);
  $$LocalUserProfilesTableTableManager get localUserProfiles =>
      $$LocalUserProfilesTableTableManager(_db, _db.localUserProfiles);
  $$BodyMetricEntriesTableTableTableManager get bodyMetricEntriesTable =>
      $$BodyMetricEntriesTableTableTableManager(
        _db,
        _db.bodyMetricEntriesTable,
      );
  $$StepRecordsTableTableTableManager get stepRecordsTable =>
      $$StepRecordsTableTableTableManager(_db, _db.stepRecordsTable);
  $$SleepRecordsTableTableTableManager get sleepRecordsTable =>
      $$SleepRecordsTableTableTableManager(_db, _db.sleepRecordsTable);
  $$WaterLogsTableTableTableManager get waterLogsTable =>
      $$WaterLogsTableTableTableManager(_db, _db.waterLogsTable);
  $$MoodLogsTableTableTableManager get moodLogsTable =>
      $$MoodLogsTableTableTableManager(_db, _db.moodLogsTable);
  $$VitalRecordsTableTableTableManager get vitalRecordsTable =>
      $$VitalRecordsTableTableTableManager(_db, _db.vitalRecordsTable);
  $$MedicationEntriesTableTableTableManager get medicationEntriesTable =>
      $$MedicationEntriesTableTableTableManager(
        _db,
        _db.medicationEntriesTable,
      );
  $$HabitEntriesTableTableTableManager get habitEntriesTable =>
      $$HabitEntriesTableTableTableManager(_db, _db.habitEntriesTable);
  $$FoodCatalogEntriesTableTableTableManager get foodCatalogEntriesTable =>
      $$FoodCatalogEntriesTableTableTableManager(
        _db,
        _db.foodCatalogEntriesTable,
      );
  $$CookingMultipliersTableTableTableManager get cookingMultipliersTable =>
      $$CookingMultipliersTableTableTableManager(
        _db,
        _db.cookingMultipliersTable,
      );
  $$MealLogsTableTableTableManager get mealLogsTable =>
      $$MealLogsTableTableTableManager(_db, _db.mealLogsTable);
  $$RecipesTableTableTableManager get recipesTable =>
      $$RecipesTableTableTableManager(_db, _db.recipesTable);
}
