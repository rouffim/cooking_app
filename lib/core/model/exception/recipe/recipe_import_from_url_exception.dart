import 'package:cool_cooker/core/model/exception/default_exception.dart';

class RecipeImportFromUrlException extends DefaultException {
  const RecipeImportFromUrlException(): super('recipe.import.fail');
}