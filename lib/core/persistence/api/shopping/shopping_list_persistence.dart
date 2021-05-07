import 'package:cool_cooker/core/model/factory/api/shopping/shopping_list_factory.dart';
import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/core/persistence/api/common_countable_persistence.dart';

abstract class ShoppingListPersistence extends CommonCountablePersistence<ShoppingListFactory, ShoppingList> {
  ShoppingListPersistence() : super('shopping_list');
}