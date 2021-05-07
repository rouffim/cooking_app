import 'package:cool_cooker/core/model/exception/default_exception.dart';

class UnreachableUrlException extends DefaultException {
  const UnreachableUrlException(): super('recipe.form.url.unreachable.error');
}