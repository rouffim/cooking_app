import 'package:clipboard/clipboard.dart';
import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_service.dart';
import 'package:cool_cooker/ui/provider/common_form_provider.dart';
import 'package:cool_cooker/ui/provider/cooking/cooking_provider.dart';
import 'package:cool_cooker/ui/provider/cooking/recipe_provider.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_provider.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class RecipeFormProvider extends CommonFormProvider<RecipeService, Recipe> {
  final  String FIELD_NAME = 'name';
  final  String FIELD_URL = 'url';
  final  String FIELD_NB_PERSONS = 'nbPersons';

  Recipe recipe;

  RecipeFormProvider() {
    addController(FIELD_NAME);
    addController(FIELD_URL);
    addController(FIELD_NB_PERSONS);

    //getController('url').text = 'https://www.cuisineaz.com/recettes/cookies-faciles-10793.aspx';
  }


  @override
  void initForm() {
    if(formItem != null) {
      getController(FIELD_NAME).text = formItem.name;
      getController(FIELD_URL).text = formItem.url;
      getController(FIELD_NB_PERSONS).text = NumberUtils.intToString(formItem.nbPersons);
    } else {
      deleteField(FIELD_NAME);
      deleteField(FIELD_URL);
      deleteField(FIELD_NB_PERSONS);
    }
  }

  @override
  Future<Recipe> submitForm(context) async {
    Recipe recipe;
    setNotReady();
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (formKey.currentState.validate()) {
      // If the form is valid
      try{
        if(!isModification() && StringUtils.isNotBlank(getController(FIELD_URL).text)) {
          try {
            recipe = await service.importRecipeFromURL(getController(FIELD_URL).text);

            if (recipe == null) {
              Provider.of<NavigatorProvider>(context, listen: false).showSnackBar(context, message: 'recipe.form.importation.error', isError: true);
              setReady();
              return null;
            }
          } catch(e) {
            Provider.of<NavigatorProvider>(context, listen: false).showSnackBar(context, message: e.toString(), isError: true);
            setReady();
            return null;
          }
        } else {
          recipe = isModification() ? formItem : new Recipe();
          recipe.url = getController(FIELD_URL).text;
          recipe.name = getController(FIELD_NAME).text;
          recipe.nbPersons = int.tryParse(getController(FIELD_NB_PERSONS).text);
        }

        await Provider.of<CookingProvider>(context, listen: false).save(recipe);

        if(isModification()) {
          Provider.of<RecipeProvider>(context, listen: false).setRecipe(recipe.uuid, true);
          Provider.of<ShoppingListProvider>(context, listen: false).modifyRecipe(recipe, relatedFkFormItem);
        }

        Provider.of<NavigatorProvider>(context, listen: false).navigateToPreviousScreenWithMessage(context);
      } catch(exception) {
        print(exception);
        Provider.of<NavigatorProvider>(context, listen: false)
            .navigateToPreviousScreenWithErrorMessage(context);
      }
    }

    setReady();
    return recipe;
  }

  void pasteUrl() {
    FlutterClipboard.paste().then((value) {
      getController(FIELD_URL).text = value;
    });
  }

  // Form validations

  String recipeUrlValidator(context) {
    String error = recipeNameValidator(context);
    if(error != null) {
      return error;
    }

    if(StringUtils.isNotBlank(getController(FIELD_URL).text) && !StringUtils.isUrl(getController(FIELD_URL).text)) {
      return FormBuilderLocalizations.of(context).urlErrorText;
    }

    return null;
  }

  String recipeNameValidator(context) {
    String nameValue = getController(FIELD_NAME).text;
    String urlValue = getController(FIELD_URL).text;
    if (StringUtils.isBlank(nameValue) && StringUtils.isBlank(urlValue)) {
      return FormBuilderLocalizations.of(context).requiredErrorText;
    } else if (StringUtils.isNotBlank(nameValue) && StringUtils.isNotBlank(urlValue)) {
      return AppLocalizations.of(context).getMessage('recipe.form.url_or_name.warn');
    }
    return null;
  }

  FormFieldValidator<String> recipeNbPersonsValidator(context) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.integer(context)
    ]);
  }
}