import 'package:cool_cooker/core/model/factory/api/recipe/recipe_factory.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/persistence/api/common_countable_persistence.dart';

abstract class RecipePersistence extends CommonCountablePersistence<RecipeFactory, Recipe> {
  RecipePersistence() : super('recipe');
}