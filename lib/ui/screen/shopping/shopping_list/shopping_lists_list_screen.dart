import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_provider.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_list/shopping_list_list_screen.dart';
import 'package:cool_cooker/ui/utils/empty_list_message_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/ui/utils/searchbar_screen.dart';
import 'package:cool_cooker/ui/utils/selection_menu_screen.dart';
import 'package:cool_cooker/ui/utils/sort_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          (context.watch<ShoppingProvider>().elements.isNotEmpty ?
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(children: [
                SearchBarScreen<ShoppingProvider>(AppLocalizations.of(context).getMessage('shopping.search')),
                SortMenuScreen(context.read<ShoppingProvider>().sortList),
              ]),
            ) :
            SizedBox()
          ),
          Flexible(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: !context.watch<ShoppingProvider>().isReady ? ProgressContainerScreen() :
                    context.watch<ShoppingProvider>().elements.isEmpty ?
                    EmptyListMessageScreen('shopping_list.list.empty') :
                      Column(
                        children: [
                          SelectableMenuScreen<ShoppingProvider>(),
                          Flexible(
                              child: ListView.builder(
                                itemCount: context.watch<ShoppingProvider>().elements.length,
                                // Provide a builder function. This is where the magic happens.
                                // Convert each item into a widget based on the type of item it is.
                                itemBuilder: (context, index) {
                                  if (index >= context.watch<ShoppingProvider>().elements.length) {
                                    if (context.watch<ShoppingProvider>().fullyLoaded) {
                                      return SizedBox(
                                        height: 75,
                                      );
                                    }
                                    context.watch<ShoppingProvider>().loadMoreData();
                                  }
                                  return ShoppingListListScreen<ShoppingProvider>(
                                      context.watch<ShoppingProvider>().elements.elementAt(index));
                                },
                            )
                          )
                        ]
                    )
                  )
              )
        ],
      ),
    );
  }
}
