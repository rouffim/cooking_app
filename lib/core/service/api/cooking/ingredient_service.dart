import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/persistence/api/cooking/ingredient_persistence.dart';
import 'package:cool_cooker/core/service/api/common_fk_service.dart';

abstract class IngredientService extends CommonFkService<IngredientPersistence, Ingredient> {
  Ingredient importIngredientFromString(String ingredientString);
}