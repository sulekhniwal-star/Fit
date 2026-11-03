/// Sensitive Data Redactor for PII scrubbing and secret suppression.
///
/// Ensures compliance with Brain/security.md by masking credentials, tokens,
/// contact details, and authentication material prior to logging or crash reporting.
class SensitiveDataRedactor {
  const SensitiveDataRedactor();

  static const String redactedPlaceholder = '[REDACTED]';
  static const String redactedEmailPlaceholder = '[REDACTED_EMAIL]';
  static const String redactedPhonePlaceholder = '[REDACTED_PHONE]';
  static const String redactedTokenPlaceholder = '[REDACTED_TOKEN]';

  static final Set<String> _sensitiveKeyPatterns = {
    'password',
    'passphrase',
    'secret',
    'token',
    'bearer',
    'jwt',
    'otp',
    'pin',
    'auth',
    'authorization',
    'cookie',
    'credential',
    'card',
    'cvv',
    'pan',
    'email',
    'phone',
    'mobile',
    'service_role',
    'access_token',
    'refresh_token',
    'private_key',
  };

  static final RegExp _jwtRegex = RegExp(
    r'eyJ[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+',
  );

  static final RegExp _bearerRegex = RegExp(
    r'Bearer\s+[A-Za-z0-9\-._~+/]+=*',
    caseSensitive: false,
  );

  static final RegExp _emailRegex = RegExp(
    r'[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+',
  );

  static final RegExp _phoneRegex = RegExp(r'(\+91[\-\s]?)?[6-9]\d{9}\b');

  static final RegExp _apiKeyRegex = RegExp(
    r'(rzp_(?:test|live)_[A-Za-z0-9]+|gsk_[A-Za-z0-9]+|sbp_[A-Za-z0-9]+)',
  );

  /// Checks if a key name matches known sensitive key patterns.
  bool isSensitiveKey(String key) {
    final lower = key.toLowerCase();
    for (final pattern in _sensitiveKeyPatterns) {
      if (lower.contains(pattern)) {
        return true;
      }
    }
    return false;
  }

  /// Redacts sensitive patterns within a freeform log string.
  String redactString(String input) {
    if (input.isEmpty) return input;

    var result = input;

    // 1. Redact JWTs
    result = result.replaceAll(_jwtRegex, redactedTokenPlaceholder);

    // 2. Redact Bearer tokens
    result = result.replaceAll(
      _bearerRegex,
      'Bearer $redactedTokenPlaceholder',
    );

    // 3. Redact API keys
    result = result.replaceAll(_apiKeyRegex, redactedTokenPlaceholder);

    // 4. Redact Emails
    result = result.replaceAll(_emailRegex, redactedEmailPlaceholder);

    // 5. Redact Phone numbers
    result = result.replaceAll(_phoneRegex, redactedPhonePlaceholder);

    return result;
  }

  /// Recursively scrubs a Map, redacting sensitive keys and scrubbing sensitive strings.
  Map<String, dynamic> redactMap(Map<String, dynamic> input) {
    final clean = <String, dynamic>{};

    for (final entry in input.entries) {
      final key = entry.key;
      final val = entry.value;

      if (isSensitiveKey(key)) {
        clean[key] = redactedPlaceholder;
      } else if (val is Map<String, dynamic>) {
        clean[key] = redactMap(val);
      } else if (val is List) {
        clean[key] = redactList(val);
      } else if (val is String) {
        clean[key] = redactString(val);
      } else {
        clean[key] = val;
      }
    }

    return clean;
  }

  /// Recursively scrubs a List.
  List<dynamic> redactList(List<dynamic> input) {
    final clean = [];

    for (final item in input) {
      if (item is Map<String, dynamic>) {
        clean.add(redactMap(item));
      } else if (item is List) {
        clean.add(redactList(item));
      } else if (item is String) {
        clean.add(redactString(item));
      } else {
        clean.add(item);
      }
    }

    return clean;
  }
}
