import 'package:cool_cooker/core/model/factory/api/shopping/shopping_item_factory.dart';
import 'package:cool_cooker/core/model/shopping/shopping_item.dart';
import 'package:cool_cooker/core/persistence/api/common_fks_persistence.dart';

abstract class ShoppingItemPersistence extends CommonFksPersistence<ShoppingItemFactory, ShoppingItem> {
  ShoppingItemPersistence() : super('shopping_item', 'list_id', 'ingredient');
}