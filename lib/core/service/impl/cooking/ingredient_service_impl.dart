import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/service/api/cooking/ingredient_service.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class IngredientServiceImpl extends IngredientService {

  @override
  Ingredient importIngredientFromString(String ingredientString) {
    ingredientString = StringUtils.cleanString(ingredientString);
    Ingredient ingredient = new Ingredient();

    if(ingredientString.startsWith(new RegExp(r'[1-9]')) && (ingredientString.contains(' de ') || ingredientString.contains(" d'"))) {
      List<String> ingredientStringSplit = StringUtils.splitFirst(ingredientString, ingredientString.contains(' de ') ? ' de ' : " d'");

      if(ingredientStringSplit[0].contains(' à ')) {
        List<String> quantities = StringUtils.splitFirst(ingredientStringSplit[0], ' à ');
        if(quantities[1].startsWith(new RegExp(r'[1-9]'))) {
          ingredientStringSplit[0] = quantities[0];
          ingredient.maxQuantity =
              NumberUtils.transformNumberFromStringToDouble(
                  StringUtils.splitFirst(quantities[1], ' ')[0]);
        }
      }

      List<String> quantities = StringUtils.splitFirst(ingredientStringSplit[0], ' ');

      ingredient.name = StringUtils.cleanString(ingredientStringSplit[1]);
      ingredient.quantity = NumberUtils.transformNumberFromStringToDouble(quantities[0]);
      ingredient.quantityUnite = StringUtils.cleanString(quantities[1]);
    } else if(!ingredientString.startsWith(new RegExp(r'[1-9]')) && ingredientString.contains(new RegExp(r'[1-9][0-9]'))) {
      int index = ingredientString.indexOf(new RegExp(r'[1-9][0-9]'));
      String part1 = ingredientString.substring(0, index);
      String part2 = ingredientString.substring(index);

      if(part2.contains(' ')) {
        List<String> quantities = StringUtils.splitFirst(part2, ' ');
        part2 = quantities[0];
        ingredient.quantityUnite = StringUtils.cleanString(quantities[1]);
      }

      ingredient.name = StringUtils.cleanString(part1);
      ingredient.quantity = NumberUtils.transformNumberFromStringToDouble(part2);

    } else if(ingredientString.startsWith(new RegExp(r'[1-9]'))) {
      List<String> parts = StringUtils.splitFirst(ingredientString, ' ');
      ingredient.name = StringUtils.cleanString(parts[1]);
      ingredient.quantity = NumberUtils.transformNumberFromStringToDouble(parts[0]);
    } else {
      ingredient.name = StringUtils.cleanString(ingredientString);
    }
    
    return ingredient;
  }
}