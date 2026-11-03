/// Structured diagnostic event representation for telemetry and analytics.
class DiagnosticEvent {
  final String name;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  DiagnosticEvent({
    required this.name,
    Map<String, dynamic>? parameters,
    DateTime? timestamp,
  }) : parameters = parameters != null
           ? Map.unmodifiable(parameters)
           : const {},
       timestamp = timestamp ?? DateTime.now();

  @override
  String toString() =>
      'DiagnosticEvent(name: $name, parameters: $parameters, timestamp: $timestamp)';
}
