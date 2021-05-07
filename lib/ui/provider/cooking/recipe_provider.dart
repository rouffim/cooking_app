import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/service/api/cooking/ingredient_service.dart';
import 'package:cool_cooker/core/service/api/cooking/instruction_service.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_service.dart';
import 'package:cool_cooker/core/service/service_locator_setup.dart';
import 'package:cool_cooker/ui/provider/selectable_provider.dart';
import 'package:cool_cooker/ui/provider/slider_model.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class RecipeProvider extends SelectableProvider {
  SliderModel recipeSlider = new SliderModel();

  String recipeUuid;
  Recipe recipe;

  var _recipeService = serviceLocator.getService<RecipeService>();
  var _ingredientService = serviceLocator.getService<IngredientService>();
  var _instructionService = serviceLocator.getService<InstructionService>();

  RecipeProvider() {
    recipeSlider.onChange = changeRecipeNbPersons;
    recipeSlider.onReset = resetRecipeNbPersons;
  }

  void setRecipe(String recipeUuid, [bool force = false]) {
    if(force || this.recipeUuid != recipeUuid) {
      recipe = null;
      relatedModel = null;
      retrieveRecipe(recipeUuid);
    }
  }

  void retrieveRecipe(String recipeUuid) async {
    if(StringUtils.isNotBlank(recipeUuid)) {
      recipe = await _recipeService.findOne(recipeUuid);

      if(recipe != null) {
        relatedModel = recipe;
        this.recipeUuid = recipeUuid;
        initialize();
        notifyListeners();
        recipe.addView();
        _recipeService.save(recipe);
      }
    }
  }

  void initialize(){
    this.recipeSlider.init();
    resetRecipeNbPersons();
  }

  void resetRecipeNbPersons () {
    this.recipeSlider.value = recipe == null || recipe.nbPersons == null ? 1 : recipe.nbPersons.toDouble();
    if(recipe != null) {
      recipe.resetNbPersons();
    }
    notifyListeners();
  }

  void changeRecipeNbPersons (double nbPersons) {
    this.recipeSlider.value = nbPersons;
    if(recipe != null) {
      recipe.changeNbPersons(nbPersons.toInt());
    }
    notifyListeners();
  }

  @override
  void removeItem(AbstractModel element) {
    if(recipe != null) {
      if(element is Ingredient) {
        recipe.ingredients.remove(element);
      }
      if(element is Instruction) {
        recipe.instructions.remove(element);
      }
    }
  }

  void addIngredient(Ingredient ingredient, [Recipe recipe]) {
    if(this.recipe != null && ingredient != null && (recipe == null || recipe == this.recipe)) {
      this.recipe.addIngredient(ingredient);
      notifyListeners();
    }
  }

  void addInstruction(Instruction instruction, [Recipe recipe]) {
    if(recipe != null && instruction != null && (recipe == null || recipe == this.recipe)) {
      recipe.addInstruction(instruction);
      notifyListeners();
    }
  }
}