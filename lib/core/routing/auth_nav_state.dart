import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthNavStatus { unauthenticated, authenticated }

class AuthNavNotifier extends ChangeNotifier {
  AuthNavStatus _status = AuthNavStatus.unauthenticated;

  AuthNavStatus get status => _status;
  bool get isAuthenticated => _status == AuthNavStatus.authenticated;

  void setAuthenticated() {
    if (_status != AuthNavStatus.authenticated) {
      _status = AuthNavStatus.authenticated;
      notifyListeners();
    }
  }

  void setUnauthenticated() {
    if (_status != AuthNavStatus.unauthenticated) {
      _status = AuthNavStatus.unauthenticated;
      notifyListeners();
    }
  }
}

/// Provider managing application authentication navigation status.
final authNavNotifierProvider = ChangeNotifierProvider<AuthNavNotifier>((ref) {
  return AuthNavNotifier();
});
