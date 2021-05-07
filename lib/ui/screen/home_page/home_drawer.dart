import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/ui/provider/cooking/cooking_provider.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_provider.dart';
import 'package:cool_cooker/ui/screen/home_page/others/compatible_recipe_websites_screen.dart';
import 'package:cool_cooker/ui/utils/alert_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomePageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
                AppLocalizations.of(context).getMessage('app.header.title')),
            decoration: BoxDecoration(
              color: Colors.blueGrey[700],
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)
                .getMessage('home.menu.compatible_websites')),
            onTap: () {
              context.read<NavigatorProvider>().navigateTo(CompatibleRecipeWebsitesScreen(), context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)
                .getMessage('home.menu.delete.all_data_title')),
            onTap: () {
              AlertUtils.showConfirmationAlert(
                  context,
                      () async {
                    await context.read<CookingProvider>().removeAll();
                    await context.read<ShoppingProvider>().removeAll();
                    context.read<NavigatorProvider>().navigateToPreviousScreen(context);
                    context.read<NavigatorProvider>().showSnackBar(context);
                  },
                  content: AppLocalizations.of(context).getMessage('home.delete.all_data_dialog_content'));
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)
                .getMessage('home.menu.reload')),
            onTap: () {
              context.read<CookingProvider>().initData();
              context.read<ShoppingProvider>().initData();
              context.read<NavigatorProvider>().navigateToPreviousScreen(context);
              context.read<NavigatorProvider>().showSnackBar(context);
            },
          ),
          ListTile(
            title: Text("Generate fake recipes"),
            onTap: () async {
              await context.read<CookingProvider>().createFakeData(1000);
              context.read<NavigatorProvider>().navigateToPreviousScreen(context);
              context.read<NavigatorProvider>().showSnackBar(context);
            },
          ),
        ],
      ),
    );
  }
}
