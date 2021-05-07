import 'package:cool_cooker/core/model/factory/api/shopping/shopping_recipe_factory.dart';
import 'package:cool_cooker/core/model/shopping/shopping_recipe.dart';
import 'package:cool_cooker/core/persistence/api/common_fks_persistence.dart';

abstract class ShoppingRecipePersistence extends CommonFksPersistence<ShoppingRecipeFactory, ShoppingRecipe> {
  ShoppingRecipePersistence() : super('shopping_recipe', 'list_id', 'recipe');
}