import 'package:cool_cooker/core/model/abstract_countable_model.dart';
import 'package:cool_cooker/core/model/shopping/shopping_item.dart';
import 'package:cool_cooker/core/persistence/api/shopping/shopping_item_persistence.dart';

class ShoppingItemPersistenceImpl extends ShoppingItemPersistence {

  @override
  Future<bool> save(ShoppingItem item, AbstractCountableModel countable) async {
    if(item != null && !item.isEmpty()) {
      try {
        int ingredientId = await sqlLitePersistence.save('ingredient', item.ingredient.toMap());

        item.ingredient.id = ingredientId;
        Map itemMap = item.toMap();
        itemMap[FK_NAME] = countable.id;

        await sqlLitePersistence.save(TABLE_NAME, itemMap);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}