import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_recipe_form_provider.dart';
import 'package:cool_cooker/ui/screen/cooking/ingredient/ingredient_list_screen.dart';
import 'package:cool_cooker/ui/screen/cooking/recipe/recipes_list_screen.dart';
import 'package:cool_cooker/ui/utils/default_scaffold_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/ui/utils/recipe_ingredients_slider_screen.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingRecipeFormScreen extends DefaultScaffoldScreen {
  final String recipeUuid;
  final AbstractModel relatedModel;

  ShoppingRecipeFormScreen({this.recipeUuid, this.relatedModel}): super(title: StringUtils.toFormTitle('shopping.recipe.form.title', recipeUuid));

  @override
  Widget scaffoldBuild(BuildContext context) {
    context.read<ShoppingRecipeFormProvider>().setItem(recipeUuid, this.relatedModel);

    return Consumer<ShoppingRecipeFormProvider>(
        builder: (context, model, child) {
          return !model.isReady ? ProgressContainerScreen() : model.step == 0 ?
            RecipesListScreen(selection: true, selectionCallback: model.setFormRecipe) :
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Text(
                        model.formRecipe.name,
                        style: TextStyle(
                          fontSize: 18, // the height between text, default is null
                        )
                    ),
                  ),
                  RecipeIngredientsSliderScreen(model.formRecipe, model.recipeSlider),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                        children: [
                          SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Checkbox(
                                  value: model.allIngredientsChecked,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    model.toggleAllIngredients();
                                  }
                              )
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Expanded(
                              child: Text(AppLocalizations.of(context).getMessage(
                                  model.allIngredientsChecked ? 'general.uncheck.all' : 'general.check.all'))
                          ),
                        ]
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    height: 4,
                  ),
                  Flexible(
                      child: ListView.builder(
                        // Let the ListView know how many items it needs to build.
                        itemCount: model.formRecipe.ingredients.length + 1,
                        // Provide a builder function. This is where the magic happens.
                        // Convert each item into a widget based on the type of item it is.
                        itemBuilder: (context, index) {
                          if(index ==  model.formRecipe.ingredients.length) {
                            return SizedBox(
                              height: 100,
                            );
                          }

                          return IngredientListScreen<ShoppingListProvider>(
                            model.formRecipe.ingredients.elementAt(index),
                            isCheckable: true,
                            callback: () {
                              context.read<ShoppingRecipeFormProvider>().toggleIngredient(index);
                            }
                          );
                        },
                      )
                  )
                ],
              )
          );
        }
    );
  }

  @override
  Widget buildFloatingActionButton(BuildContext context){
    return context.watch<ShoppingRecipeFormProvider>().step == 0 ? null : Builder(
        builder: (BuildContext context)  {
          return FloatingActionButton(
            onPressed: () {
              context.read<ShoppingRecipeFormProvider>().submitForm(context);
            },
            child: Icon(Icons.check),
          );
        }
    );
  }
}