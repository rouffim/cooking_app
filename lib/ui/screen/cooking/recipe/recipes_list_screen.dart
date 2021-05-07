import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/ui/provider/cooking/cooking_provider.dart';
import 'package:cool_cooker/ui/screen/cooking/recipe/recipe_list_screen.dart';
import 'package:cool_cooker/ui/utils/empty_list_message_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/ui/utils/searchbar_screen.dart';
import 'package:cool_cooker/ui/utils/selection_menu_screen.dart';
import 'package:cool_cooker/ui/utils/sort_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipesListScreen extends StatelessWidget {
  final bool selection;
  final Function selectionCallback;

  RecipesListScreen({this.selection = false, this.selectionCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          (context.watch<CookingProvider>().elements.isNotEmpty ?
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                  children: [
                    SearchBarScreen<CookingProvider>(AppLocalizations.of(context).getMessage('recipe.search')),
                    //SearchBarBrowseScreen<CookingProvider>(),
                    SortMenuScreen(context.read<CookingProvider>().sortList),
                  ]
              ),
            ) :
            SizedBox()
          ),
          Flexible(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: !context.watch<CookingProvider>().isReady ? ProgressContainerScreen() :
                  context.watch<CookingProvider>().elements.isEmpty ?
                  EmptyListMessageScreen('recipe.list.empty') :
                    Column(
                      children: [
                        SelectableMenuScreen<CookingProvider>(),
                        Flexible(
                            child: ListView.builder(
                              itemCount: context.watch<CookingProvider>().elements.length,
                              // Provide a builder function. This is where the magic happens.
                              // Convert each item into a widget based on the type of item it is.
                              itemBuilder: (context, index) {
                                if (index >= context.watch<CookingProvider>().elements.length) {
                                  if(context.watch<CookingProvider>().fullyLoaded) {
                                    return SizedBox(
                                      height: 75,
                                    );
                                  }
                                  context.watch<CookingProvider>().loadMoreData();
                                }
                                Recipe recipe = context.watch<CookingProvider>().elements.elementAt(index);
                                return RecipeListScreen<CookingProvider>(
                                    recipe,
                                    selection: selection,
                                    selectionCallback: selectionCallback
                                );
                              },
                            )
                        )
                      ]
                    )
                )
            )
        ],
      )
    );
  }
}