import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/provider/selectable_provider.dart';
import 'package:cool_cooker/ui/screen/cooking/recipe/recipe_screen.dart';
import 'package:cool_cooker/ui/utils/selectable_item_screen.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeListScreen<T extends SelectableProvider> extends StatelessWidget {
  final Recipe recipe;
  final bool selection;
  final Function selectionCallback;

  RecipeListScreen(this.recipe, {this.selection = false, this.selectionCallback});

  @override
  Widget build(BuildContext context) {
    return SelectableItemScreen<T>(
        item: recipe,
        selectAction: () {
          if(selection) {
            if(this.selectionCallback != null) {
              this.selectionCallback(context, recipe);
            } else {
              print('Selection callback must not be null when selection is true.');
            }
          } else {
            context.read<NavigatorProvider>().navigateTo(RecipeScreen(recipe.uuid), context);
          }
        },
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: LimitedBox(
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                  ),
                  Expanded (
                    child : Column(
                        crossAxisAlignment : CrossAxisAlignment.start,
                        children: [
                          Text(StringUtils.toDisplayableString(recipe .name)),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 4),
                            child: Text(
                              StringUtils.isNotBlank(recipe .url) ?
                                StringUtils.urlToDomain(StringUtils.toDisplayableString(recipe .url)) :
                                AppLocalizations.of(context).getMessage('recipe.yours'),
                              style: TextStyle(
                                color: recipe.isSelected ? Colors.white70 : Colors.blue,
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Icon(
                        Icons.chevron_right,
                        color: Colors.white
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }
}