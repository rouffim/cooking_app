import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/persistence/api/cooking/recipe_persistence.dart';
import 'package:cool_cooker/core/service/api/common_countable_service.dart';

abstract class RecipeService extends CommonCountableService<RecipePersistence, Recipe> {
  Future<Recipe> importRecipeFromURL(String url);
}