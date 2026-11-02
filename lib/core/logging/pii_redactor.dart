class PiiRedactor {
  static final RegExp _emailRegex = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );

  static final RegExp _phoneRegex = RegExp(
    r'(?:\+?91[\s-]?)?[6789]\d{9}',
  );

  static final RegExp _bearerTokenRegex = RegExp(
    r'Bearer\s+[A-Za-z0-9\-._~+/]+=*',
    caseSensitive: false,
  );

  static final RegExp _jwtRegex = RegExp(
    r'eyJ[a-zA-Z0-9_-]{10,}\.[a-zA-Z0-9_-]{10,}\.[a-zA-Z0-9_-]{10,}',
  );

  static String redact(String input) {
    var sanitized = input;
    sanitized = sanitized.replaceAll(_jwtRegex, '[REDACTED_JWT]');
    sanitized = sanitized.replaceAll(_bearerTokenRegex, 'Bearer [REDACTED_TOKEN]');
    sanitized = sanitized.replaceAll(_emailRegex, '[REDACTED_EMAIL]');
    sanitized = sanitized.replaceAll(_phoneRegex, '[REDACTED_PHONE]');
    return sanitized;
  }

  static Map<String, dynamic> redactMap(Map<String, dynamic> map) {
    final sanitized = <String, dynamic>{};
    for (final entry in map.entries) {
      final key = entry.key.toLowerCase();
      if (key.contains('password') ||
          key.contains('secret') ||
          key.contains('token') ||
          key.contains('authorization')) {
        sanitized[entry.key] = '[REDACTED_SECRET]';
      } else if (entry.value is String) {
        sanitized[entry.key] = redact(entry.value as String);
      } else if (entry.value is Map<String, dynamic>) {
        sanitized[entry.key] = redactMap(entry.value as Map<String, dynamic>);
      } else {
        sanitized[entry.key] = entry.value;
      }
    }
    return sanitized;
  }
}

