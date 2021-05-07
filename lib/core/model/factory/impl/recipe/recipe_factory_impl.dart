import 'dart:convert';

import 'package:cool_cooker/core/model/factory/api/recipe/recipe_factory.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class RecipeFactoryImpl extends RecipeFactory {

  @override
  Recipe transformOneFromJson(json) {
    return Recipe.fromJson(StringUtils.isString(json) ? jsonDecode(json) : json);
  }

}