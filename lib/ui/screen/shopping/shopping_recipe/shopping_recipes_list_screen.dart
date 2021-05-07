import 'package:cool_cooker/core/model/shopping/shopping_recipe.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_provider.dart';
import 'package:cool_cooker/ui/screen/cooking/recipe/recipe_list_screen.dart';
import 'package:cool_cooker/ui/utils/empty_list_message_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/ui/utils/selection_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingRecipesListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return context.watch<ShoppingListProvider>().shoppingList == null ? ProgressContainerScreen() : Container(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: context.watch<ShoppingListProvider>().shoppingList.recipes.isEmpty
                ? EmptyListMessageScreen('shopping_list.recipes.list.empty')
                : Column(children: [
                    SelectableMenuScreen<ShoppingListProvider>(),
                    Flexible(
                        child: ListView.builder(
                      itemCount: context.watch<ShoppingListProvider>().shoppingList.recipes.length,
                      // Provide a builder function. This is where the magic happens.
                      // Convert each item into a widget based on the type of item it is.
                      itemBuilder: (context, index) {
                        if (index >= context.watch<ShoppingListProvider>().shoppingList.recipes.length) {
                          return SizedBox(
                            height: 75,
                          );
                        }
                        ShoppingRecipe recipe = context.watch<ShoppingListProvider>().shoppingList.recipes.elementAt(index);
                        return RecipeListScreen<ShoppingListProvider>(recipe.recipe);
                      },
                    )
                    )
                  ]
        )
    );
  }
}
