class NavigatorMessage {
  final String message;
  final bool isI18n;
  final bool isError;

  NavigatorMessage(this.message, {this.isI18n = true, this.isError = false});
}