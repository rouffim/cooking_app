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

class RecipeJdfImporter extends RecipeSiteImporter {

  @override
  Recipe importRecipeFromUrl(String url, String body) {
    Recipe recipe = new Recipe();
    recipe.url = url;
    recipe.siteType = RecipeSiteType.JDF;

    var document = parse(body);

    // Replace malformed HTML
    body = StringUtils.replaceMalformedHtmlTags(body);

    // Recipe name
    String recipeTitle = StringUtils.cleanString(document.querySelector('.app_recipe_title_page').text);
    recipe.name = recipeTitle;

    // Recipe nb persons
    String nbPersons = document.querySelector('#numberPerson').text;
    recipe.nbPersons = int.tryParse(nbPersons);

    // Recipe ingredients section
    Element ingredientsSection = document.querySelector('.app_recipe_list');

    // Recipe ingredients
    recipe.ingredients = importRecipeIngredients(ingredientsSection);

    // Recipe instructions section
    Element instructionsSection = document.querySelector('.bu_cuisine_main_recipe');
    // Recipe ingredients
    recipe.instructions = importRecipeInstructions(instructionsSection);

    return recipe;
  }

  List<Ingredient> importRecipeIngredients(Element section) {
    List<Ingredient> ingredients = new List();
    List<Element> ingredientsHTML = section.querySelectorAll('.app_recipe_ing_title');

    for (Element ingredientHTML in ingredientsHTML) {
      Ingredient ingredient = new Ingredient();

      ingredient.name = StringUtils.cleanString(ingredientHTML.querySelector('a').text);
      ingredient.quantity = NumberUtils.transformNumberFromStringToDouble(ingredientHTML.querySelector('span').attributes['data-quantity']);
      String quantityUnite = ingredientHTML.querySelector('span').attributes['data-mesure-singular'];
      if(StringUtils.isNotBlank(quantityUnite))
        ingredient.quantityUnite = quantityUnite;

      ingredients.add(ingredient);
    }
    return ingredients;
  }

  List<Instruction> importRecipeInstructions(Element section) {
    List<Instruction> instructions = new List();
    List<Element> instructionsHTML = section.querySelectorAll('li.bu_cuisine_recette_prepa');

    for (Element instructionHTML in instructionsHTML) {
      instructionHTML.querySelectorAll('span').forEach((element) => element.remove());
      instructionHTML.querySelectorAll('div').forEach((element) => element.remove());

      Instruction instruction = new Instruction();

      instruction.name = StringUtils.cleanString(instructionHTML.text);
      instruction.order = instructions.length + 1;

      instructions.add(instruction);
    }

    return instructions;
  }
}