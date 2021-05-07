import 'dart:convert';

import 'package:cool_cooker/core/model/factory/api/shopping/shopping_recipe_factory.dart';
import 'package:cool_cooker/core/model/shopping/shopping_recipe.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class ShoppingRecipeFactoryImpl extends ShoppingRecipeFactory {

  @override
  ShoppingRecipe transformOneFromJson(json) {
    return ShoppingRecipe.fromJson(StringUtils.isString(json) ? jsonDecode(json) : json);
  }

}