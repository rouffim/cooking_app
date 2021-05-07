import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/core/service/api/cooking/ingredient_service.dart';
import 'package:cool_cooker/ui/provider/common_form_provider.dart';
import 'package:cool_cooker/ui/provider/cooking/recipe_provider.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_provider.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class IngredientFormProvider extends CommonFormProvider<IngredientService, Ingredient> {
  final String FIELD_NAME = 'ingredient_name';
  final String FIELD_QUANTITY = 'ingredient_quantity';
  final String FIELD_MAX_QUANTITY = 'ingredient_max_quantity';
  final String FIELD_QUANTITY_UNITE = 'ingredient_quantity_unite';

  IngredientFormProvider() {
    addController(FIELD_NAME);
    addController(FIELD_QUANTITY);
    addController(FIELD_MAX_QUANTITY);
    addController(FIELD_QUANTITY_UNITE);
  }

  @override
  void initForm() {
    if(formItem != null) {
      getController(FIELD_NAME).text = formItem.name;
      getController(FIELD_QUANTITY).text = NumberUtils.doubleToString(formItem.quantity);
      getController(FIELD_MAX_QUANTITY).text = NumberUtils.doubleToString(formItem.maxQuantity);
      getController(FIELD_QUANTITY_UNITE).text = formItem.quantityUnite;
    } else {
      deleteField(FIELD_NAME);
      deleteField(FIELD_QUANTITY);
      deleteField(FIELD_MAX_QUANTITY);
      deleteField(FIELD_QUANTITY_UNITE);
    }
  }

  @override
  Future<Ingredient> submitForm(BuildContext context) async {
    Ingredient ingredient;
    setNotReady();
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (formKey.currentState.validate()) {
      // If the form is valid
      try {
        if(!isModification()) {
          ingredient = new Ingredient();
          ingredient.name = getController(FIELD_NAME).text;

          Ingredient imported = service.importIngredientFromString(ingredient.name);

          if(imported != null){
            ingredient.name = imported.name;
            ingredient.quantity = imported.quantity;
            ingredient.maxQuantity = imported.maxQuantity;
            ingredient.quantityUnite = imported.quantityUnite;
          }
        } else {
          ingredient = formItem;
          ingredient.name = getController(FIELD_NAME).text;
          ingredient.quantity = NumberUtils.transformNumberFromStringToDouble(
              getController(FIELD_QUANTITY).text);
          ingredient.maxQuantity =
              NumberUtils.transformNumberFromStringToDouble(
                  getController(FIELD_MAX_QUANTITY).text);
          ingredient.quantityUnite = getController(FIELD_QUANTITY_UNITE).text;
        }

        if (await service.save(ingredient, relatedFkFormItem)) {
          if (relatedFkFormItem is Recipe) {
            Provider.of<RecipeProvider>(context, listen: false)
                .addIngredient(ingredient, relatedFkFormItem);
          } else if (relatedFkFormItem is ShoppingList) {
            Provider.of<ShoppingListProvider>(context, listen: false)
                .modifyIngredient(ingredient, relatedFkFormItem);
          } else {
            throw Exception();
          }
          Provider.of<NavigatorProvider>(context, listen: false)
              .navigateToPreviousScreenWithMessage(context);
        } else {
          throw Exception();
        }
      } catch(exception) {
        print(exception);
        Provider.of<NavigatorProvider>(context, listen: false)
            .navigateToPreviousScreenWithErrorMessage(context);
      }
    }

    setReady();
    return ingredient;
  }

  // Form validations

  FormFieldValidator<String> ingredientNameValidator(context) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(context),
    ]);
  }

  FormFieldValidator<String> ingredientQuantityValidator(context) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.numeric(context),
    ]);
  }

  String ingredientMaxQuantityValidator(context) {
    double quantity = NumberUtils.transformNumberFromStringToDouble(getController(FIELD_QUANTITY).text);
    double maxQuantity = NumberUtils.transformNumberFromStringToDouble(getController(FIELD_MAX_QUANTITY).text);

    if(NumberUtils.doubleIsNotBlank(maxQuantity) && NumberUtils.doubleIsNotBlank(quantity) && maxQuantity <= quantity) {
      return AppLocalizations.of(context).getMessage('ingredient.form.max_quantity.error');
    }

    return null;
  }

  FormFieldValidator<String> ingredientQuantityUniteValidator(context) {
    return FormBuilderValidators.compose([
      //FormBuilderValidators.required(context),
    ]);
  }

}