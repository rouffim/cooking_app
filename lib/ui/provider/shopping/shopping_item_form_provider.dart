import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/shopping/shopping_item.dart';
import 'package:cool_cooker/core/service/api/cooking/ingredient_service.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_item_service.dart';
import 'package:cool_cooker/core/service/service_locator_setup.dart';
import 'package:cool_cooker/ui/provider/common_form_provider.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ShoppingItemFormProvider extends CommonFormProvider<ShoppingItemService, ShoppingItem> {
  final String FIELD_NAME = 'item_name';

  var _ingredientService = serviceLocator.getService<IngredientService>();

  ShoppingItemFormProvider() {
    addController(FIELD_NAME);
  }

  @override
  void initForm() {
    if(formItem != null) {
      getController(FIELD_NAME).text = formItem.ingredient.name;
    } else {
      deleteField(FIELD_NAME);
    }
  }

  @override
  Future<ShoppingItem> submitForm(context) async {
    ShoppingItem shoppingItem;
    setNotReady();
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (formKey.currentState.validate()) {
      // If the form is valid
      try{
        if(isModification()) {
          shoppingItem = formItem;

          if(shoppingItem.ingredient != null) {
            shoppingItem.ingredient.name = getController(FIELD_NAME).text;
          }
        } else {
          shoppingItem = ShoppingItem();
          shoppingItem.ingredient = _ingredientService.importIngredientFromString(getController(FIELD_NAME).text);
        }

        if(shoppingItem.ingredient == null) {
          shoppingItem.ingredient = Ingredient();
          shoppingItem.ingredient.name = getController(FIELD_NAME).text;
        }

        if(await service.save(shoppingItem, relatedFkFormItem)) {
          if(relatedFkFormItem != null) {
            Provider.of<ShoppingListProvider>(context, listen: false)
                .addItem(shoppingItem, relatedFkFormItem);
          } else {
            throw Exception();
          }
          Provider.of<NavigatorProvider>(context, listen: false).navigateToPreviousScreenWithMessage(context);
          notifyListeners();
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

    return shoppingItem;
  }

  // Form validations

  FormFieldValidator<String> shoppingItemNameValidator(context) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(context),
    ]);
  }
}