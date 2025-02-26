class GlobalException implements Exception {
  GlobalException(this.error, [this.stack]);

  String error;
  String? stack;
}
