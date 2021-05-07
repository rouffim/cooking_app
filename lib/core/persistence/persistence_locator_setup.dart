import 'package:cool_cooker/core/persistence/api/cooking/ingredient_persistence.dart';
import 'package:cool_cooker/core/persistence/api/cooking/instruction_persistence.dart';
import 'package:cool_cooker/core/persistence/api/cooking/recipe_persistence.dart';
import 'package:cool_cooker/core/persistence/api/shopping/shopping_item_persistence.dart';
import 'package:cool_cooker/core/persistence/api/shopping/shopping_list_persistence.dart';
import 'package:cool_cooker/core/persistence/api/shopping/shopping_recipe_persistence.dart';
import 'package:cool_cooker/core/persistence/api/sql_lite_persistence.dart';
import 'package:cool_cooker/core/persistence/impl/cooking/ingredient_persistence_impl.dart';
import 'package:cool_cooker/core/persistence/impl/cooking/instruction_persistence_impl.dart';
import 'package:cool_cooker/core/persistence/impl/cooking/recipe_persistence_impl.dart';
import 'package:cool_cooker/core/persistence/impl/shopping/shopping_item_persistence.dart';
import 'package:cool_cooker/core/persistence/impl/shopping/shopping_list_persistence_impl.dart';
import 'package:cool_cooker/core/persistence/impl/shopping/shopping_recipe_persistence_impl.dart';
import 'package:cool_cooker/core/persistence/impl/sql_lite_persistence_impl.dart';
import 'package:cool_cooker/core/persistence/persistence_locator.dart';

PersistenceLocator persistenceLocator = PersistenceLocator.instance;

void persistenceLocatorSetup() {
  persistenceLocator.addPersistence<SqlLitePersistence>(SqlLitePersistenceImpl());
  persistenceLocator.addPersistence<IngredientPersistence>(IngredientPersistenceImpl());
  persistenceLocator.addPersistence<InstructionPersistence>(InstructionPersistenceImpl());
  persistenceLocator.addPersistence<ShoppingItemPersistence>(ShoppingItemPersistenceImpl());
  persistenceLocator.addPersistence<ShoppingRecipePersistence>(ShoppingRecipePersistenceImpl());
  persistenceLocator.addPersistence<RecipePersistence>(RecipePersistenceImpl());
  persistenceLocator.addPersistence<ShoppingListPersistence>(ShoppingListPersistenceImpl());
}
