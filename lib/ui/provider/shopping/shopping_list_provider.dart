import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/model/shopping/shopping_item.dart';
import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/core/model/shopping/shopping_recipe.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_item_service.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_list_service.dart';
import 'package:cool_cooker/core/service/service_locator_setup.dart';
import 'package:cool_cooker/ui/provider/selectable_provider.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_item/shopping_items_list_screen.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';

class ShoppingListProvider extends SelectableProvider {
  final GlobalKey<AnimatedListState> itemsListKey = GlobalKey();

  var _shoppingListService = serviceLocator.getService<ShoppingListService>();
  var _shoppingItemService = serviceLocator.getService<ShoppingItemService>();

  String shoppingListUuid;
  ShoppingList shoppingList;

  void setShoppingList(String shoppingListUuid) {
    if(this.shoppingListUuid!= shoppingListUuid) {
      this.shoppingList = null;
      relatedModel = null;
      retrieveShoppingList(shoppingListUuid);
    }
  }

  void retrieveShoppingList(String shoppingListUuid) async {
    if(StringUtils.isNotBlank(shoppingListUuid)) {
      shoppingList = await _shoppingListService.findOne(shoppingListUuid);

      if(shoppingList != null) {
        relatedModel = shoppingList;
        this.shoppingListUuid = shoppingListUuid;
        notifyListeners();
        shoppingList.addView();
        _shoppingListService.save(shoppingList);
      }
    }
  }

  @override
  void checkItem(AbstractModel item) async {
    if(item != null && (item is ShoppingItem || item is Ingredient)) {
      item.toggleCheck();
      ShoppingItem shoppingItem = (item is ShoppingItem ? item : (item as Ingredient).fromShoppingItem);
      ShoppingList shoppingListCopy = shoppingList.clone();

      if(shoppingItem != null) {
        int index = shoppingList.items.indexOf(shoppingItem);
        if(index > -1) {
          AnimatedListRemovedItemBuilder builder = (context, animation) {
            return buildIngredientListItem(shoppingItem, animation);
          };
          shoppingList.items.removeAt(index);
          itemsListKey.currentState.removeItem(index, builder);
          await Future.delayed(Duration(milliseconds: 250));
        }

        shoppingListCopy.sortItems();

        await _shoppingItemService.save(shoppingItem, shoppingListCopy);

        index = shoppingListCopy.items.indexOf(shoppingItem);
        if(index > -1) {
          shoppingList.items.insert(index, shoppingItem);
          itemsListKey.currentState.insertItem(index);
        }
      }

      notifyListeners();
    }
  }

  @override
  void removeItem(AbstractModel element) {
    if(shoppingList != null) {
      if(element is ShoppingItem) {
        shoppingList.items.remove(element);
      }
      if(element is ShoppingRecipe) {
        List list = shoppingList.recipes;
        list.remove(element);
        shoppingList.recipes = list;
      }
    }
  }

  void addItem(ShoppingItem item, [ShoppingList shoppingList]) {
    if(this.shoppingList != null && item != null && (shoppingList == null || shoppingList == this.shoppingList)) {
      this.shoppingList.addItem(item);
      notifyListeners();
    }
  }

  void addShoppingRecipe(ShoppingRecipe recipe, [ShoppingList shoppingList]) {
    if(this.shoppingList != null && recipe != null && (shoppingList == null || shoppingList == this.shoppingList)) {
      shoppingList.addRecipe(recipe);
      notifyListeners();
    }
  }

  void modifyRecipe(Recipe recipe, ShoppingRecipe shoppingRecipe) {
    if(this.shoppingList != null && recipe != null && !recipe.isEmpty() && shoppingRecipe != null) {
      ShoppingRecipe existingShoppingRecipe = this.shoppingList.recipes
          .firstWhere((element) => element == shoppingRecipe);

      if(existingShoppingRecipe != null) {
        existingShoppingRecipe.recipe = recipe;
        notifyListeners();
      }
    }
  }

  void modifyIngredient(Ingredient ingredient, ShoppingList shoppingList) {
    if(this.shoppingList != null && ingredient != null && shoppingList == this.shoppingList) {
      ShoppingItem item = this.shoppingList.items.firstWhere((element) =>
        !element.isEmpty() && element.ingredient == ingredient);

      if(item != null) {
        item.ingredient = ingredient;
        notifyListeners();
      }
    }
  }
}