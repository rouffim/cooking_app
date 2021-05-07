import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/ui/provider/selectable_provider.dart';
import 'package:cool_cooker/ui/utils/selectable_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientListScreen<T extends SelectableProvider> extends StatelessWidget {
  final Ingredient ingredient;
  final bool isCheckable;
  final Function callback;

  IngredientListScreen(this.ingredient, {this.isCheckable = false, this.callback});

  @override
  Widget build(BuildContext context) {
    return SelectableItemScreen<T>(
      item: ingredient,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: LimitedBox(
            child: Row(
          children: [
            isCheckable ?
            SizedBox(
              height: 20.0,
              width: 20.0,
              child: Checkbox(
                value: ingredient.checked,
                activeColor: Colors.green,
                onChanged: (value) {
                  context.read<T>().checkItem(ingredient);

                  if(callback != null) {
                    callback();
                  }
                }
              )
            )
            :SizedBox(),
            SizedBox(
              width: 18,
            ),
            Expanded(
              child: Text(ingredient.name,
                  style: TextStyle(
                    height: 1.4, // the height between text, default is null
                  )),
            ),
            Text(ingredient.displayQuantity(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color : Colors.white70
                )
            ),
          ],
        ))
      )
    );
  }
}
