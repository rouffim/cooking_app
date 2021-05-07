import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/core/persistence/api/shopping/shopping_list_persistence.dart';
import 'package:cool_cooker/core/service/api/common_countable_service.dart';

abstract class ShoppingListService extends CommonCountableService<ShoppingListPersistence, ShoppingList> {

}