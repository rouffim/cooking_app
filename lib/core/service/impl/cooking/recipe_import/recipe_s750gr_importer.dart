import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/model/recipe/recipe_site_type.dart';
import 'package:cool_cooker/core/service/api/cooking/ingredient_service.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_import/recipe_site_importer.dart';
import 'package:cool_cooker/core/service/service_locator_setup.dart';
import 'package:cool_cooker/utils/dom_utils.dart';
import 'package:html/dom.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:html/parser.dart' show parse;

class RecipeS750grImporter extends RecipeSiteImporter {

  @override
  Recipe importRecipeFromUrl(String url, String body) {
    Recipe recipe = new Recipe();
    recipe.url = url;
    recipe.siteType = RecipeSiteType.S750gr;

    var document = parse(body);

    // Replace malformed HTML
    body = StringUtils.replaceMalformedHtmlTags(body);

    // Recipe name
    String recipeTitle = StringUtils.cleanString(document.querySelector('.u-title-page').text);
    recipe.name = recipeTitle;

    // Recipe nb persons
    String nbPersons = document.querySelector('.ingredient-variator-label').text.split(' ')[0];
    recipe.nbPersons = int.tryParse(nbPersons);

    // Recipe ingredients section
    Element ingredientsSection = document.querySelector('.recipe-ingredients');

    // Recipe ingredients
    recipe.ingredients = importRecipeIngredients(ingredientsSection);

    // Recipe instructions section
    Element instructionsSection = document.querySelector('.recipe-steps');
    // Recipe ingredients
    recipe.instructions = importRecipeInstructions(instructionsSection);

    return recipe;
  }

  List<Ingredient> importRecipeIngredients(Element section) {
    List<Ingredient> ingredients = new List();
    List<Element> ingredientsHTML = section.querySelectorAll('.recipe-ingredients-item-label');

    for (Element ingredientHTML in ingredientsHTML) {
      String toTreat = ingredientHTML.text;

      Ingredient ingredient =
        serviceLocator.getService<IngredientService>().importIngredientFromString(toTreat);

      ingredients.add(ingredient);
    }

    return ingredients;
  }

  List<Instruction> importRecipeInstructions(Element section) {
    List<Instruction> instructions = new List();
    List<Element> instructionsHTML = section.querySelectorAll('.recipe-steps-text');

    for (Element instructionHTML in instructionsHTML) {
      instructionHTML = instructionHTML.querySelector('p');
      Instruction instruction = new Instruction();

      instruction.name = StringUtils.cleanString(instructionHTML.text);
      instruction.order = instructions.length + 1;

      instructions.add(instruction);
    }

    return instructions;
  }
}