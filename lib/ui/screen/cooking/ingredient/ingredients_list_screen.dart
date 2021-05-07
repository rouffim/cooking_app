import 'package:cool_cooker/ui/provider/cooking/recipe_provider.dart';
import 'package:cool_cooker/ui/screen/cooking/ingredient/ingredient_list_screen.dart';
import 'package:cool_cooker/ui/utils/empty_list_message_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/ui/utils/selection_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientsListScreen extends StatefulWidget {
  @override
  _IngredientsListScreenState createState() => _IngredientsListScreenState();
}

class _IngredientsListScreenState extends State<IngredientsListScreen>
    with AutomaticKeepAliveClientMixin<IngredientsListScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return context.watch<RecipeProvider>().recipe == null ? ProgressContainerScreen() : Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
        child: context.watch<RecipeProvider>().recipe.ingredients.isEmpty ?
          EmptyListMessageScreen('recipe.ingredients.list.empty') :
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableMenuScreen<RecipeProvider>(),
              Flexible(
                  child: ListView.builder(
                // Let the ListView know how many items it needs to build.
                itemCount: context.watch<RecipeProvider>().recipe.ingredients.length + 1,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  if(index == context.watch<RecipeProvider>().recipe.ingredients.length) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 250,
                    );
                  }
                  return IngredientListScreen<RecipeProvider>(
                      context.watch<RecipeProvider>().recipe.ingredients.elementAt(index)
                  );
                },
              ))
          ]
        )
    );
  }
}
