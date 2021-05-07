import 'dart:convert';

import 'package:cool_cooker/core/model/factory/api/shopping/shopping_item_factory.dart';
import 'package:cool_cooker/core/model/shopping/shopping_item.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class ShoppingItemFactoryImpl extends ShoppingItemFactory {

  @override
  ShoppingItem transformOneFromJson(json) {
    return ShoppingItem.fromJson(StringUtils.isString(json) ? jsonDecode(json) : json);
  }

}