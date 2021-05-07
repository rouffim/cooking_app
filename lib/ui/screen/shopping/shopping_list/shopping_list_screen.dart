import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_provider.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_item/shopping_item_form_screen.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_item/shopping_items_list_screen.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_recipe/shopping_recipe_form_screen.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_recipe/shopping_recipes_list_screen.dart';
import 'package:cool_cooker/ui/utils/countable_menu_screen.dart';
import 'package:cool_cooker/ui/utils/tab_scaffold_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ShoppingListScreen extends TabScaffoldScreen<ShoppingListProvider> {
  final String shoppingListUuid;

  ShoppingListScreen(this.shoppingListUuid): super(length: 2);

  @override
  Widget scaffoldBuild(BuildContext context) {
    context.read<ShoppingListProvider>().setShoppingList(shoppingListUuid);

    return TabBarView(
      children: [
        Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: []
                ),
              ),
              Flexible(
                child: ShoppingItemsListScreen(),
              )
            ],
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    children: []
                ),
              ),
              Flexible(
                child: ShoppingRecipesListScreen(),
              )
            ]
          ),
        ]
      );
  }

  @override
  Widget buildFloatingActionButton(BuildContext context){
    ShoppingList shoppingList = context.watch<ShoppingListProvider>().shoppingList;

    return Builder(
        builder: (BuildContext context)  {
      return FloatingActionButton(
        onPressed: () {
          if (DefaultTabController.of(context).index == 0) {
            context.read<NavigatorProvider>().navigateTo(ShoppingItemFormScreen(relatedModel: shoppingList), context);
          } else {
            context.read<NavigatorProvider>().navigateTo(ShoppingRecipeFormScreen(relatedModel: shoppingList), context);
          }
        },
        child: Icon(Icons.add),
      );
    }
    );
  }

  @override
  String screenTitle(BuildContext context) {
    ShoppingList shoppingList = context.watch<ShoppingListProvider>().shoppingList;

    return shoppingList != null ? shoppingList.name : '';
  }


  @override
  List<Widget> buildActions(BuildContext context) {
    ShoppingList shoppingList = context.watch<ShoppingListProvider>().shoppingList;

    return [
      CountableMenuScreen(
        context.read<ShoppingProvider>().doAction,
        shoppingList,
      )
    ];
  }

  @override
  List<Widget> buildTabs(BuildContext context) {
    return [
      Tab(
        icon: Icon(Icons.format_list_bulleted),
        text: AppLocalizations.of(context).getMessage('shopping.items.title'),
      ),
      Tab(
        icon: Icon(Icons.restaurant),
        text: AppLocalizations.of(context).getMessage('shopping.recipes.title'),
      ),
    ];
  }
}
