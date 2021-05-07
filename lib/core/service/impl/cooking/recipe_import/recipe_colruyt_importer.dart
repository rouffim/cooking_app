import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/model/recipe/recipe_site_type.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_import/recipe_site_importer.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:html/dom.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:html/parser.dart' show parse;

class RecipeColruytImporter extends RecipeSiteImporter {

  @override
  Recipe importRecipeFromUrl(String url, String body) {
    Recipe recipe = new Recipe();
    recipe.url = url;
   // recipe.siteType = RecipeSiteType.COLRUYT;

    var document = parse(body);

    // Replace malformed HTML
    body = StringUtils.replaceMalformedHtmlTags(body);

    // Recipe name
    String recipeTitle = StringUtils.cleanString(document.querySelector('.recipe-detail__header h1').text);
    recipe.name = recipeTitle;

    // Recipe nb persons
    String nbPersons = document.querySelector('.recipe-detail__quantity-form-info').text.split(' ')[0];
    recipe.nbPersons = int.tryParse(nbPersons);

    // Recipe ingredients section
    Element ingredientsSection = document.querySelector('.recipe-detail__ingredients-list');

    // Recipe ingredients
    recipe.ingredients = importRecipeIngredients(ingredientsSection);

    // Recipe instructions section
    Element instructionsSection = document.querySelector('.tabs .tabs__content:first-child .tabs__info');
    // Recipe ingredients
    recipe.instructions = importRecipeInstructions(instructionsSection);

    return recipe;
  }

  List<Ingredient> importRecipeIngredients(Element section) {
    List<Ingredient> ingredients = new List();
    List<Element> ingredientsHTML = section.querySelectorAll('li');

    for (Element ingredientHTML in ingredientsHTML) {
      Ingredient ingredient = new Ingredient();
      List<Element> ingredientElementsHTML = ingredientHTML.querySelectorAll('span');

      ingredient.name = StringUtils.cleanString(ingredientElementsHTML.first.text);
      List<String> quantityStrings = StringUtils.splitFirst(StringUtils.cleanString(ingredientElementsHTML.last.text), ' ');
      ingredient.quantity = NumberUtils.transformNumberFromStringToDouble(quantityStrings[0]);
      if(quantityStrings.length > 1)
        ingredient.quantityUnite = quantityStrings[1];

      ingredients.add(ingredient);
    }

    return ingredients;
  }

  List<Instruction> importRecipeInstructions(Element section) {
    List<Instruction> instructions = new List();
    List<Element> listsHTML = section.querySelectorAll('ol');
    List<Element> instructionsHTML;
    int order = 1;

    if(listsHTML.length == 2) {
      Instruction instruction = new Instruction();
      instruction.name = StringUtils.cleanString(listsHTML.elementAt(0).text);
      instruction.order = 0;
      instructions.add(instruction);
      instructionsHTML = listsHTML.elementAt(1).querySelectorAll('li');
    } else {
      instructionsHTML = listsHTML.elementAt(0).querySelectorAll('li');
    }

    for (Element instructionHTML in instructionsHTML) {
      Instruction instruction = new Instruction();
      instruction.name = StringUtils.cleanString(instructionHTML.text);
      instruction.order = order;
      instructions.add(instruction);
      order++;
    }

    return instructions;
  }
}