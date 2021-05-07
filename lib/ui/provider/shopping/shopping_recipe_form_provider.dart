import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/model/shopping/shopping_recipe.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_service.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_list_service.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_recipe_service.dart';
import 'package:cool_cooker/core/service/service_locator_setup.dart';
import 'package:cool_cooker/ui/provider/common_form_provider.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_provider.dart';
import 'package:cool_cooker/ui/provider/slider_model.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:provider/provider.dart';

class ShoppingRecipeFormProvider extends CommonFormProvider<ShoppingRecipeService, ShoppingRecipe> {
  SliderModel recipeSlider = new SliderModel();
  int step = 0;
  bool allIngredientsChecked = true;
  String formRecipeUuid;
  Recipe formRecipe;

  var _recipeService = serviceLocator.getService<RecipeService>();
  var _shoppingListService = serviceLocator.getService<ShoppingListService>();

  ShoppingRecipeFormProvider() {
    recipeSlider.onChange = changeRecipeNbPersons;
    recipeSlider.onReset = resetRecipeNbPersons;
  }

  @override
  void initForm() {

  }

  @override
  Future<ShoppingRecipe> submitForm(context) async {
    ShoppingRecipe shoppingRecipe;

    try{
      if (StringUtils.isNotBlank(formRecipeUuid)) {
        if (step == 0) {
          formRecipe = await _recipeService.findOne(formRecipeUuid);

          if (formRecipe != null) {
            if (formRecipe.ingredients.isEmpty) {
              shoppingRecipe = await _saveRecipeForm(context);
            } else {
              recipeSlider.init();
              recipeSlider.value = NumberUtils.intIsBlank(formRecipe.nbPersons) ?
                0 : formRecipe.nbPersons.toDouble();
              toggleAllIngredients(true);
              secondStep(context);
              notifyListeners();
            }
          } else {
            throw Exception();
          }
        } else {
          shoppingRecipe = await _saveRecipeForm(context);
          firstStep(context);
          notifyListeners();
        }
      } else {
        throw Exception();
      }

      if(step != 1) {
        Provider.of<NavigatorProvider>(context, listen: false)
            .navigateToPreviousScreenWithMessage(context);
      }

    } catch(exception) {
      print(exception);
      Provider.of<NavigatorProvider>(context, listen: false)
          .navigateToPreviousScreenWithErrorMessage(context);
    }

    return shoppingRecipe;
  }

  Future<ShoppingRecipe> _saveRecipeForm(context) async {
    Provider.of<ShoppingListProvider>(context, listen: false).isSelectable = true;
    // If the form is valid
    ShoppingRecipe shoppingRecipe = isModification() ? formItem : new ShoppingRecipe();
    formRecipe.makeIngredientsModifiedQuantityDefinitive();
    shoppingRecipe.recipe = formRecipe;

    if (await service.save(shoppingRecipe, relatedFkFormItem)) {
      if(relatedFkFormItem != null) {
        Provider.of<ShoppingListProvider>(context, listen: false)
            .addShoppingRecipe(shoppingRecipe, relatedFkFormItem);

        if(!await _shoppingListService.save(relatedFkFormItem)) {
          throw Exception();
        }
      } else {
        throw Exception();
      }
      notifyListeners();
      return shoppingRecipe;
    }  else {
      throw Exception();
    }
  }

  void firstStep(context) {
    Provider.of<ShoppingListProvider>(context, listen: false).isSelectable = true;
    this.step = 0;
  }

  void secondStep(context) {
    Provider.of<ShoppingListProvider>(context, listen: false).isSelectable = false;
    this.step = 1;
  }

  void toggleAllIngredients([bool check]) {
    allIngredientsChecked = check != null ? check : !allIngredientsChecked;
    formRecipe.ingredients.forEach((ingredient) => ingredient.checked = allIngredientsChecked);
    notifyListeners();
  }

  void toggleIngredient(int index) {
    if(formRecipe != null) {
      Ingredient ingredient = formRecipe.ingredients.elementAt(index);

      if (ingredient != null) {
        notifyListeners();
      }
    }
  }

  void resetRecipeNbPersons () {
    this.recipeSlider.value = formRecipe == null || formRecipe.nbPersons == null ? 1 : formRecipe.nbPersons.toDouble();
    if(formRecipe != null) {
      formRecipe.resetNbPersons();
    }
    notifyListeners();
  }

  void changeRecipeNbPersons (double nbPersons) {
    this.recipeSlider.value = nbPersons;
    if(formRecipe != null) {
      formRecipe.changeNbPersons(nbPersons.toInt());
    }
    notifyListeners();
  }

  void setFormRecipe(context, Recipe recipe) async {
    if(recipe != null) {
      formRecipeUuid = recipe.uuid;
      submitForm(context);
    }
  }
}