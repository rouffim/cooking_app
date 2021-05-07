import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/core/persistence/api/shopping/shopping_item_persistence.dart';
import 'package:cool_cooker/core/persistence/api/shopping/shopping_list_persistence.dart';
import 'package:cool_cooker/core/persistence/api/shopping/shopping_recipe_persistence.dart';
import 'package:cool_cooker/core/persistence/persistence_locator_setup.dart';

class ShoppingListPersistenceImpl extends ShoppingListPersistence {

  @override
  Future<ShoppingList> findOne(String uuid) async {
    ShoppingList shoppingList;
    Map result = await sqlLitePersistence.selectByUuid(TABLE_NAME, uuid);

    if(result != null) {
      shoppingList = factory.transformOneFromJson(result);
      shoppingList.items = await _shoppingItemPersistence.findAllByFk(shoppingList.id);
      shoppingList.recipes = await _shoppingRecipePersistence.findAllByFk(shoppingList.id);
    }

    return shoppingList;
  }

  @override
  Future<bool> save(ShoppingList shoppingList) async {
    if(shoppingList != null && !shoppingList.isEmpty()) {
      shoppingList.id = await sqlLitePersistence.save(TABLE_NAME, shoppingList.toMap());
      await _shoppingItemPersistence.saveAll(shoppingList.items, shoppingList);
      await _shoppingRecipePersistence.saveAll(shoppingList.recipes, shoppingList);
      return true;
    }
    return false;
  }


  ShoppingItemPersistence get _shoppingItemPersistence {
    return persistenceLocator.getPersistence<ShoppingItemPersistence>();
  }

  ShoppingRecipePersistence get _shoppingRecipePersistence {
    return persistenceLocator.getPersistence<ShoppingRecipePersistence>();
  }
}