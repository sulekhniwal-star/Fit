import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

abstract class EncryptionKeyProvider {
  /// Returns a 256-bit hex-encoded encryption key for SQLCipher pragma setup.
  Future<String> getEncryptionKey();

  /// Wipes any cached keys from memory.
  void clearMemoryCache();
}

class DefaultEncryptionKeyProvider implements EncryptionKeyProvider {
  static const String _keyStorageKey = 'fitkarma_sqlcipher_key_v1';
  String? _cachedKey;

  @override
  Future<String> getEncryptionKey() async {
    if (_cachedKey != null) {
      return _cachedKey!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedKey = prefs.getString(_keyStorageKey);
      if (storedKey != null && storedKey.isNotEmpty) {
        _cachedKey = storedKey;
        return storedKey;
      }

      final key = _generateSecureKey();
      await prefs.setString(_keyStorageKey, key);
      _cachedKey = key;
      return key;
    } catch (_) {
      final fallbackKey = _generateSecureKey();
      _cachedKey = fallbackKey;
      return fallbackKey;
    }
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

