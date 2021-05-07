import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/screen/cooking/recipe/recipe_form_screen.dart';
import 'package:cool_cooker/ui/screen/cooking/recipe/recipes_list_screen.dart';
import 'package:cool_cooker/ui/screen/home_page/home_drawer.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_list/shopping_list_form_screen.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_list/shopping_lists_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: HomePageDrawer(),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.restaurant),
                  text: AppLocalizations.of(context).getMessage('cooking.title'),
                ),
                Tab(
                  icon: Icon(Icons.storefront),
                  text: AppLocalizations.of(context).getMessage('shopping.title'),
                ),
              ],
            ),
            title: Text(AppLocalizations.of(context).getMessage('app.title')),
          ),
          body: TabBarView(
            children: [
              RecipesListScreen(),
              ShoppingListsListScreen(),
            ],
          ),
          floatingActionButton: Builder(
            builder: (BuildContext context) {
              return FloatingActionButton(
                onPressed: () {
                  if(DefaultTabController.of(context).index == 0) {
                    context.read<NavigatorProvider>().navigateTo(RecipeFormScreen(), context);
                  } else {
                    context.read<NavigatorProvider>().navigateTo(ShoppingListFormScreen(), context);
                  }
                },
                child: Icon(Icons.add),
              );
            }
          )
        ),
      );
  }
}
