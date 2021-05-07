import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/ui/provider/cooking/cooking_provider.dart';
import 'package:cool_cooker/ui/provider/cooking/recipe_provider.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/screen/cooking/ingredient/ingredient_form_screen.dart';
import 'package:cool_cooker/ui/screen/cooking/ingredient/ingredients_list_screen.dart';
import 'package:cool_cooker/ui/screen/cooking/instruction/instruction_form_screen.dart';
import 'package:cool_cooker/ui/screen/cooking/instruction/instructions_list_screen.dart';
import 'package:cool_cooker/ui/utils/countable_menu_screen.dart';
import 'package:cool_cooker/ui/utils/recipe_ingredients_slider_screen.dart';
import 'package:cool_cooker/ui/utils/tab_scaffold_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RecipeScreen extends TabScaffoldScreen<RecipeProvider> {
  final String recipeUuid;

  RecipeScreen(this.recipeUuid): super(length: 2);

  @override
  Widget scaffoldBuild(BuildContext context) {
    context.read<RecipeProvider>().setRecipe(recipeUuid);
    Recipe recipe = context.watch<RecipeProvider>().recipe;

    return TabBarView(
      children: [
        Column(
          children: [
            Consumer<RecipeProvider>(
              builder: (context, model, child) {
                return RecipeIngredientsSliderScreen(model.recipe, model.recipeSlider);
              }
            ),
            Flexible(
              child: recipe == null ? SizedBox() : IngredientsListScreen(),
            )
          ],
        ),
        Column(
          children: [
            Flexible(
              child: recipe == null ? SizedBox() : InstructionsListScreen(),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget buildFloatingActionButton(BuildContext context){
    Recipe recipe = context.watch<RecipeProvider>().recipe;

    return Builder(
        builder: (BuildContext context)  {
          return FloatingActionButton(
            onPressed: () {
              if (DefaultTabController.of(context).index == 0) {
                context.read<NavigatorProvider>().navigateTo(IngredientFormScreen(relatedModel: recipe), context);
              } else {
                context.read<NavigatorProvider>().navigateTo(InstructionFormScreen(relatedModel: recipe), context);
              }
            },
            child: Icon(Icons.add),
          );
        }
    );
  }

  @override
  String screenTitle(BuildContext context) {
    Recipe recipe = context.watch<RecipeProvider>().recipe;

    return recipe != null ? recipe.name : '';
  }

  @override
  List<Widget> buildTabs(BuildContext context) {
    return [
      Tab(
        icon: Icon(Icons.food_bank),
        text: AppLocalizations.of(context).getMessage('ingredients.title'),
      ),
      Tab(
        icon: Icon(Icons.format_list_numbered),
        text: AppLocalizations.of(context).getMessage('instructions.title'),
      ),
    ];
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    Recipe recipe = context.watch<RecipeProvider>().recipe;

    return recipe == null ? [] : [
      CountableMenuScreen(
        context.read<CookingProvider>().doAction,
        recipe,
        true
      )
    ];
  }
}
