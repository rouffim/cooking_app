import 'dart:convert';

import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:cool_cooker/utils/string_utils.dart';

abstract class CommonFactory<T extends AbstractModel> {

  T transformOneFromJson(json);

  String transformOneToJson(T ingredient) {
    return jsonEncode(ingredient);
  }

  List<T> transformListFromJson(json) {
    if(!StringUtils.isString(json) || (StringUtils.isNotBlank(json) && json != '[""]' && json != '[]')) {
      List elements = (StringUtils.isString(json) ? jsonDecode(json) : json) as List;
      return elements.map((element) => transformOneFromJson(element)).toList();
    }
    return new List();
  }

  String transformListToJson(List<T> ingredients) {
    return jsonEncode(ingredients);
  }
}