import 'package:cool_cooker/core/service/api/cooking/ingredient_service.dart';
import 'package:cool_cooker/core/service/api/cooking/instruction_service.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_service.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_item_service.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_list_service.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_recipe_service.dart';
import 'package:cool_cooker/core/service/impl/cooking/ingredient_service_impl.dart';
import 'package:cool_cooker/core/service/impl/cooking/instruction_service_impl.dart';
import 'package:cool_cooker/core/service/impl/cooking/recipe_service_impl.dart';
import 'package:cool_cooker/core/service/impl/shopping/shopping_item_service_impl.dart';
import 'package:cool_cooker/core/service/impl/shopping/shopping_list_service_impl.dart';
import 'package:cool_cooker/core/service/impl/shopping/shopping_recipe_service_impl.dart';
import 'package:cool_cooker/core/service/service_locator.dart';

ServiceLocator serviceLocator = ServiceLocator.instance;

void serviceLocatorSetup() {
  serviceLocator.addService<InstructionService>(InstructionServiceImpl());
  serviceLocator.addService<ShoppingRecipeService>(ShoppingRecipeServiceImpl());
  serviceLocator.addService<ShoppingItemService>(ShoppingItemServiceImpl());
  serviceLocator.addService<IngredientService>(IngredientServiceImpl());
  serviceLocator.addService<RecipeService>(RecipeServiceImpl());
  serviceLocator.addService<ShoppingListService>(ShoppingListServiceImpl());
}
