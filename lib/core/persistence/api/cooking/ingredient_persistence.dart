import 'package:cool_cooker/core/model/factory/api/recipe/ingredient_factory.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/persistence/api/common_fk_persistence.dart';

abstract class IngredientPersistence extends CommonFkPersistence<IngredientFactory, Ingredient> {
  IngredientPersistence() : super('ingredient', 'recipe_id');
}