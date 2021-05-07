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

class RecipeAzImporter extends RecipeSiteImporter {

  @override
  Recipe importRecipeFromUrl(String url, String body) {
    Recipe recipe = new Recipe();
    recipe.url = url;
    recipe.siteType = RecipeSiteType.AZ;

    var document = parse(body);

    // Replace malformed HTML
    body = StringUtils.replaceMalformedHtmlTags(body);

    // Recipe name
    String recipeTitle = document.querySelector('.recipe-title').innerHtml.trim();
    recipe.name = recipeTitle;

    // Recipe ingredients section
    Element ingredientsSection = document.querySelector('.ingredients');

    // Recipe nb persons
    String nbPersons = ingredientsSection.querySelector('#ContentPlaceHolder_LblRecetteNombre').innerHtml.split('Pers.')[0];
    recipe.nbPersons = int.tryParse(nbPersons);

    // Recipe ingredients
    recipe.ingredients = importRecipeIngredients(ingredientsSection);

    // Recipe instructions section
    Element instructionsSection = document.querySelector('.instructions');
    DomUtils.removeElement(instructionsSection, '.borderSection_header');
    DomUtils.removeElement(instructionsSection, '.recipe_video');

    // Recipe ingredients
    recipe.instructions = importRecipeInstructions(instructionsSection);

    return recipe;
  }

  List<Ingredient> importRecipeIngredients(Element section) {
    List<Ingredient> ingredients = new List();
    List<Element> ingredientsHTML = section.querySelectorAll('li');

    for (Element ingredientHTML in ingredientsHTML) {
      String toTreat = ingredientHTML.querySelector('span').innerHtml;
      Ingredient ingredient =
      serviceLocator.getService<IngredientService>().importIngredientFromString(toTreat);
      ingredients.add(ingredient);
    }

    return ingredients;
  }

  List<Instruction> importRecipeInstructions(Element section) {
    List<Instruction> instructions = new List();
    List<Element> instructionsHTML = section.querySelectorAll('li');

    for (Element instructionHTML in instructionsHTML) {
      String toTreat = instructionHTML.querySelector('p').text;
      Instruction instruction = new Instruction();
      instruction.name = StringUtils.cleanString(toTreat);
      instruction.order = instructions.length + 1;
      instructions.add(instruction);
    }

    return instructions;
  }
}