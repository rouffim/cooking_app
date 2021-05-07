import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_list_service.dart';
import 'package:cool_cooker/ui/provider/common_form_provider.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_provider.dart';
import 'package:cool_cooker/utils/DateUtils.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ShoppingListFormProvider extends CommonFormProvider<ShoppingListService, ShoppingList> {
  final  String FIELD_NAME = 'name';

  ShoppingListFormProvider() {
    addController(FIELD_NAME);
  }


  @override
  void initForm() {
    if(formItem != null) {
      getController(FIELD_NAME).text = formItem.name;
    } else {
      deleteField(FIELD_NAME);
    }
  }

  @override
  Future<ShoppingList> submitForm(context) async {
    ShoppingList shoppingList;
    setNotReady();
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (formKey.currentState.validate()) {
      // If the form is valid
      try{
        shoppingList = isModification() ? formItem : new ShoppingList();
        shoppingList.name = getController(FIELD_NAME).text;

        if(StringUtils.isBlank(shoppingList.name)) {
          shoppingList.name = DateUtils.nowToString();
        }

        await Provider.of<ShoppingProvider>(context, listen: false).save(shoppingList);
        Provider.of<NavigatorProvider>(context, listen: false).navigateToPreviousScreenWithMessage(context);
      } catch(exception) {
        print(exception);
        Provider.of<NavigatorProvider>(context, listen: false)
            .navigateToPreviousScreenWithErrorMessage(context);
      }
    }

    setReady();
    return shoppingList;
  }

  // Form validations

  FormFieldValidator<String> shoppingListNameValidator(context) {
    return FormBuilderValidators.compose([
      //FormBuilderValidators.required(context),
    ]);
  }
}