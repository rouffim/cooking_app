import 'package:cool_cooker/core/model/recipe/recipe.dart';

abstract class RecipeImporter {
  Recipe importRecipeFromUrl(String url, String body);
}