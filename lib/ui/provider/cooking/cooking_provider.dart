import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/model/recipe/recipe_site_type.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_service.dart';
import 'package:cool_cooker/ui/provider/common_provider.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class CookingProvider extends CommonProvider<RecipeService, Recipe> {

  Future<void> createFakeData(int nb) async {
    for(int i = 0; i < nb; i++) {
      Recipe recipe = new Recipe();

      recipe.name = i.toString() + " " + StringUtils.generateShortString();
      recipe.nbPersons = NumberUtils.randomInt(1, 12);
      recipe.url = StringUtils.generateFakeUrl();
      recipe.siteType = RecipeSiteType.NONE;

      int numberOfIngredients = NumberUtils.randomInt(4, 16);

      for(int i = 0; i < numberOfIngredients; i++) {
        Ingredient ingredient = new Ingredient();
        ingredient.name = StringUtils.generateMediumString();
        ingredient.quantity = NumberUtils.randomDouble(1, 999);
        ingredient.quantityUnite = StringUtils.generateWordString();
        recipe.addIngredient(ingredient);
      }

      int numberOfInstructions = NumberUtils.randomInt(2, 12);

      for(int i = 0; i < numberOfInstructions; i++) {
        Instruction instruction = new Instruction();
        instruction.name = StringUtils.generateLongString();
        recipe.addInstruction(instruction);
      }

      await service.save(recipe);
    }
    notifyListeners();
  }

}