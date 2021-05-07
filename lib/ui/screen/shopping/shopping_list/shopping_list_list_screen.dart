import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/provider/selectable_provider.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_list/shopping_list_screen.dart';
import 'package:cool_cooker/ui/utils/selectable_item_screen.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListListScreen<T extends SelectableProvider> extends StatelessWidget {
  final ShoppingList shoppingList;

  ShoppingListListScreen(this.shoppingList);

  @override
  Widget build(BuildContext context) {
    return SelectableItemScreen<T>(
      item: shoppingList,
      selectAction: () {
        if(shoppingList != null) {
          context.read<NavigatorProvider>().navigateTo(
              ShoppingListScreen(shoppingList.uuid), context);
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
                          Text(StringUtils.toDisplayableString(shoppingList.name)),
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