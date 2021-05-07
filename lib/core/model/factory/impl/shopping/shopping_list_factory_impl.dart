import 'dart:convert';

import 'package:cool_cooker/core/model/factory/api/shopping/shopping_list_factory.dart';
import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class ShoppingListFactoryImpl extends ShoppingListFactory {

  @override
  ShoppingList transformOneFromJson(json) {
    return ShoppingList.fromJson(StringUtils.isString(json) ? jsonDecode(json) : json);
  }

}