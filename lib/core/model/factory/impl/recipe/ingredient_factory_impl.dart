import 'dart:convert';

import 'package:cool_cooker/core/model/factory/api/recipe/ingredient_factory.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class IngredientFactoryImpl extends IngredientFactory {

  @override
  Ingredient transformOneFromJson(json) {
    return Ingredient.fromJson(StringUtils.isString(json) ? jsonDecode(json) : json);
  }

}