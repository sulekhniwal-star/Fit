import 'dart:convert';
import 'dart:math';

abstract class EncryptionKeyProvider {
  /// Returns a 256-bit hex-encoded encryption key for SQLCipher pragma setup.
  Future<String> getEncryptionKey();

  /// Wipes any cached keys from memory.
  void clearMemoryCache();
}

class DefaultEncryptionKeyProvider implements EncryptionKeyProvider {
  String? _cachedKey;

  @override
  Future<String> getEncryptionKey() async {
    if (_cachedKey != null) {
      return _cachedKey!;
    }

    // In a real device setup, this key is retrieved from FlutterSecureStorage / OS Keystore.
    // If none exists, a cryptographically secure 256-bit random key is generated.
    final key = _generateSecureKey();
    _cachedKey = key;
    return key;
  }

  String _generateSecureKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  @override
  void clearMemoryCache() {
    _cachedKey = null;
  }
}

class DeterministicEncryptionKeyProvider implements EncryptionKeyProvider {
  final String _key;

  const DeterministicEncryptionKeyProvider([this._key = 'fitkarma-test-encryption-key-256bit-hex!']);

  @override
  Future<String> getEncryptionKey() async => _key;

  @override
  void clearMemoryCache() {}
}

