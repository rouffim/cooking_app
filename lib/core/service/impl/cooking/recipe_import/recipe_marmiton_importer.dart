import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/model/recipe/recipe_site_type.dart';
import 'package:cool_cooker/core/service/api/cooking/ingredient_service.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_import/recipe_site_importer.dart';
import 'package:cool_cooker/core/service/service_locator_setup.dart';
import 'package:cool_cooker/utils/dom_utils.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:html/dom.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:html/parser.dart' show parse;

class RecipeMarmitonImporter extends RecipeSiteImporter {

  @override
  Recipe importRecipeFromUrl(String url, String body) {
    Recipe recipe = new Recipe();
    recipe.url = url;
    recipe.siteType = RecipeSiteType.MARMITON;

    var document = parse(body);

    // Replace malformed HTML
    body = StringUtils.replaceMalformedHtmlTags(body);

    // Recipe name
    String recipeTitle = StringUtils.cleanString(document.querySelector('.main-title').text);
    recipe.name = recipeTitle;

    // Recipe nb persons
    String nbPersons = document.querySelector('.recipe-infos__quantity__value').text;
    recipe.nbPersons = int.tryParse(nbPersons);

    // Recipe ingredients section
    Element ingredientsSection = document.querySelector('.recipe-ingredients__list');

    // Recipe ingredients
    recipe.ingredients = importRecipeIngredients(ingredientsSection);

    // Recipe instructions section
    Element instructionsSection = document.querySelector('.recipe-preparation__list');
    // Recipe ingredients
    recipe.instructions = importRecipeInstructions(instructionsSection);

    return recipe;
  }

  List<Ingredient> importRecipeIngredients(Element section) {
    List<Ingredient> ingredients = new List();
    List<Element> ingredientsHTML = section.querySelectorAll('.recipe-ingredients__list__item');

    for (Element ingredientHTML in ingredientsHTML) {
      ingredientHTML = ingredientHTML.querySelector('div');

      String quantity = ingredientHTML.querySelector('.recipe-ingredient-qt').text;
      String follow = ingredientHTML.querySelector('.ingredient').text;
      String toTreat = (StringUtils.isNotBlank(quantity) ? quantity + ' ' : '') + follow;

      Ingredient ingredient =
        serviceLocator.getService<IngredientService>().importIngredientFromString(toTreat);

      ingredients.add(ingredient);
    }

    return ingredients;
  }

  List<Instruction> importRecipeInstructions(Element section) {
    List<Instruction> instructions = new List();
    List<Element> instructionsHTML = section.querySelectorAll('li.recipe-preparation__list__item');

    for (Element instructionHTML in instructionsHTML) {
      Instruction instruction = new Instruction();

      instruction.name = StringUtils.cleanString(instructionHTML.text);
      instruction.order = instructions.length + 1;

      instructions.add(instruction);
    }

    return instructions;
  }
}