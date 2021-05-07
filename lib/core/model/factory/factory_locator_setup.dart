import 'package:cool_cooker/core/model/factory/api/recipe/ingredient_factory.dart';
import 'package:cool_cooker/core/model/factory/api/recipe/instruction_factory.dart';
import 'package:cool_cooker/core/model/factory/api/recipe/recipe_factory.dart';
import 'package:cool_cooker/core/model/factory/api/shopping/shopping_item_factory.dart';
import 'package:cool_cooker/core/model/factory/api/shopping/shopping_list_factory.dart';
import 'package:cool_cooker/core/model/factory/api/shopping/shopping_recipe_factory.dart';
import 'package:cool_cooker/core/model/factory/impl/recipe/ingredient_factory_impl.dart';
import 'package:cool_cooker/core/model/factory/impl/recipe/instruction_factory_impl.dart';
import 'package:cool_cooker/core/model/factory/impl/recipe/recipe_factory_impl.dart';
import 'package:cool_cooker/core/model/factory/impl/shopping/shopping_item_factory_impl.dart';
import 'package:cool_cooker/core/model/factory/impl/shopping/shopping_list_factory_impl.dart';
import 'package:cool_cooker/core/model/factory/impl/shopping/shopping_recipe_factory.dart';

import 'factory_locator.dart';

FactoryLocator factoryLocator = FactoryLocator.instance;

void factoryLocatorSetup() {
  factoryLocator.addFactory<RecipeFactory>(RecipeFactoryImpl());
  factoryLocator.addFactory<IngredientFactory>(IngredientFactoryImpl());
  factoryLocator.addFactory<InstructionFactory>(InstructionFactoryImpl());
  factoryLocator.addFactory<ShoppingListFactory>(ShoppingListFactoryImpl());
  factoryLocator.addFactory<ShoppingItemFactory>(ShoppingItemFactoryImpl());
  factoryLocator.addFactory<ShoppingRecipeFactory>(ShoppingRecipeFactoryImpl());
}
