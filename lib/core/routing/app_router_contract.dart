/// Contract boundary for application routing and navigation.
abstract interface class AppRouterContract {
  void navigateTo(String path, {Object? extra});
  void replaceWith(String path, {Object? extra});
  void pop();
  String get currentRoute;
}

