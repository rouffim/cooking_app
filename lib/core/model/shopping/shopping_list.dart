import 'package:cool_cooker/core/model/abstract_countable_model.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/factory/api/shopping/shopping_item_factory.dart';
import 'package:cool_cooker/core/model/factory/api/shopping/shopping_recipe_factory.dart';
import 'package:cool_cooker/core/model/factory/factory_locator_setup.dart';
import 'package:cool_cooker/core/model/shopping/shopping_item.dart';
import 'package:cool_cooker/core/model/shopping/shopping_recipe.dart';
import 'package:cool_cooker/utils/list_utils.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class ShoppingList extends AbstractCountableModel {
  List<ShoppingItem> _items = new List();
  Map<String, ShoppingRecipe> _recipes = new Map();

  ShoppingList() : super();

  ShoppingList.name(String name) : super.name(name);

  ShoppingList.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if(json['items'] != null) {
      this.items =
          this._shoppingItemFactory.transformListFromJson(json['items']);
    }

    if(json['recipes'] != null) {
      recipes = this._shoppingRecipeFactory.transformListFromJson(json['recipes']);
    }
  }

  List<ShoppingItem> get items {
    if(_items == null) {
      _items = new List();
    }
    return _items;
  }
  set items(List<ShoppingItem> items) {
    this._items = items;
  }
  void addItem(ShoppingItem item, [bool checkChecked = false]) {
    if(item != null && !item.isEmpty() && (!checkChecked || item.checked)) {
      if(!containsItem(item)) {
        if (_items == null) {
          _items = new List();
        }

        String nameToCompare = item.ingredient.name.toLowerCase();

        ShoppingItem match = items.firstWhere((element) =>
        !element.isEmpty() &&
            element.ingredient.name.toLowerCase() == nameToCompare,
            orElse: () => null);

        if (match != null) {
          if (item.ingredient.quantity != null) {
            if (StringUtils.isBlank(match.ingredient.quantityUnite)) {
              match.ingredient.quantityUnite = item.ingredient.quantityUnite;
            }

            if ((StringUtils.isBlank(match.ingredient.quantityUnite) &&
                StringUtils.isBlank(item.ingredient.quantityUnite)) ||
                (match.ingredient.quantityUnite.toLowerCase() ==
                    item.ingredient.quantityUnite.toLowerCase())) {
              if (item.ingredient.maxQuantity != null) {
                if (match.ingredient.maxQuantity == null) {
                  match.ingredient.maxQuantity = item.ingredient.maxQuantity;
                } else {
                  match.ingredient.maxQuantity += item.ingredient.maxQuantity;
                }
              }

              if (match.ingredient.quantity == null) {
                match.ingredient.quantity = item.ingredient.quantity;
              } else {
                match.ingredient.quantity += item.ingredient.quantity;
              }
            }
          }
        } else {
          item.checked = false;
          this.items.add(item);
        }
      } else {
        ListUtils.replace(this.items, item);
      }
    }
  }
  bool containsItem(ShoppingItem item) {
    if(item != null) {
      return this.items.contains(item);
    }
    return false;
  }

  List<ShoppingRecipe> get recipes {
    if(_recipes == null) {
      _recipes = new Map();
    }
    return _recipes.values.toList();
  }
  set recipes(List<ShoppingRecipe> recipes) {
    this._recipes = new Map();
    for(ShoppingRecipe recipe in recipes) {
      addRecipe(recipe);
    }
  }
  void addRecipe(ShoppingRecipe recipe) {
    if(recipe != null && !recipe.isEmpty()) {
      if(!containsRecipe(recipe)) {
        if (_recipes == null) {
          _recipes = new Map();
        }

        recipe.recipe.ingredients.forEach((ingredient) =>
            addItem(new ShoppingItem.fromIngredient(ingredient.clone()), true)
        );

        if (!this._recipes.containsKey(recipe.recipe.uuid)) {
          this._recipes[recipe.recipe.uuid] = recipe;
        }
      } else {
        this._recipes[recipe.recipe.uuid] = recipe;
      }
    }
  }
  bool containsRecipe(ShoppingRecipe recipe) {
    if(recipe != null) {
      return this.recipes.contains(recipe);
    }
    return false;
  }

  ShoppingItemFactory get _shoppingItemFactory {
    return factoryLocator.getFactory<ShoppingItemFactory>();
  }

  ShoppingRecipeFactory get _shoppingRecipeFactory {
    return factoryLocator.getFactory<ShoppingRecipeFactory>();
  }


  void lazyLoad(ShoppingList fullList) {
    if(fullList != null) {
      this.items = fullList.items;
      this.recipes = fullList.recipes;
    }
  }

  void sortItems() {
    this.items.sort((a, b) {
      if(a.isEmpty())
        return -1;
      if(b.isEmpty())
        return 1;

      if(!a.ingredient.checked && !b.checked)
        return a.creationDate.compareTo(b.creationDate);

      if(a.checked && b.checked)
        return a.creationDate.compareTo(b.creationDate);

      return a.checked ? 1 : -1;
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    List items = this.items != null ? this.items.map((i) => i.toJson()).toList() : null;
    List recipes = this.recipes != null ? this.recipes.map((i) => i.toJson()).toList() : null;

    json['items'] = items;
    json['recipes'] = recipes;

    return json;
  }

  @override
  AbstractModel clone([AbstractModel toClone]) {
    ShoppingList clone = new ShoppingList();

    super.clone(clone);

    clone.items = this.items.map((item) => item.clone() as ShoppingItem).toList();
    clone.recipes = this.recipes.map((recipe) => recipe.clone() as ShoppingRecipe).toList();

    return clone;
  }

}