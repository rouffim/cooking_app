class DefaultException implements Exception {
  final String _message;

  const DefaultException([this._message = ""]);

  @override
  String toString() {
    return _message;
  }
}