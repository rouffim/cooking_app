import 'package:cool_cooker/core/model/shopping/shopping_item.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_provider.dart';
import 'package:cool_cooker/ui/screen/cooking/ingredient/ingredient_list_screen.dart';
import 'package:cool_cooker/ui/utils/empty_list_message_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/ui/utils/selection_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingItemsListScreen extends  StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return context.watch<ShoppingListProvider>().shoppingList == null ? ProgressContainerScreen() : Container(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: context.watch<ShoppingListProvider>().shoppingList.items.isEmpty ?
        EmptyListMessageScreen('shopping.items.list.empty') :
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableMenuScreen<ShoppingListProvider>(),
              Flexible(
                  child: AnimatedList(
                    key: context.read<ShoppingListProvider>().itemsListKey,
                    // Let the ListView know how many items it needs to build.
                    initialItemCount: context.watch<ShoppingListProvider>().shoppingList.items.length + 1,
                    // Provide a builder function. This is where the magic happens.
                    // Convert each item into a widget based on the type of item it is.
                    itemBuilder: (context, index, animation) {
                      if(index == context.watch<ShoppingListProvider>().shoppingList.items.length) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 270,
                        );
                      }

                      ShoppingItem item = context
                          .watch<ShoppingListProvider>()
                          .shoppingList
                          .items
                          .elementAt(index);

                      return buildIngredientListItem(item, animation);
                    },
                  )
              )
            ]
          )
    );
  }
}

Widget buildIngredientListItem(ShoppingItem item, animation) {
  if(!item.isEmpty()) {
    return SizeTransition(
      sizeFactor: animation,
      child: IngredientListScreen<ShoppingListProvider>(
        item.ingredient,
        isCheckable: true,
      )
    );
  } else {
    return SizedBox();
  }
}