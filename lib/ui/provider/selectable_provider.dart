import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/model_type_enum.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/model/shopping/shopping_item.dart';
import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/core/model/shopping/shopping_recipe.dart';
import 'package:cool_cooker/core/service/api/common_service.dart';
import 'package:cool_cooker/core/service/api/cooking/ingredient_service.dart';
import 'package:cool_cooker/core/service/api/cooking/instruction_service.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_service.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_item_service.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_list_service.dart';
import 'package:cool_cooker/core/service/api/shopping/shopping_recipe_service.dart';
import 'package:cool_cooker/core/service/service_locator_setup.dart';
import 'package:cool_cooker/ui/enums/selectable_item_settings_enum.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/screen/cooking/ingredient/ingredient_form_screen.dart';
import 'package:cool_cooker/ui/screen/cooking/instruction/instruction_form_screen.dart';
import 'package:cool_cooker/ui/screen/cooking/recipe/recipe_form_screen.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_item/shopping_item_form_screen.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_list/shopping_list_form_screen.dart';
import 'package:cool_cooker/ui/screen/shopping/shopping_recipe/shopping_recipe_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class SelectableProvider extends ChangeNotifier {
  final SHARABLE_SEPARATOR = "======================";
  final SHARABLE_ITEM = " - ";
  final SHARABLE_SECTION_TITLE_END = " : ";
  final SHARABLE_EMPTY_LINE = "";
  final EOF = "\n";
  bool lock = false;
  bool isSelectable = true;
  bool isSelectionOn = false;
  AbstractModel relatedModel;
  Set<AbstractModel> selectedElements = new Set();

  SelectableProvider() {
    unSelectAll();
  }


  void removeItem(AbstractModel item);


  void select(AbstractModel element, [bool simpleTap = false]) {
    if (isSelectable && element != null && (!simpleTap || isSelectionOn)) {
      if (!selectedElements.contains(element)) {
        isSelectionOn = true;

        selectedElements.add(element);
        element.isSelected = true;

        notifyListeners();
      } else {
        unSelect(element);
      }
    }
  }

  void unSelect(AbstractModel element) {
    if (isSelectable && element != null) {
      selectedElements.remove(element);
      element.isSelected = false;

      if (selectedElements.isEmpty) {
        isSelectionOn = false;
      }

      notifyListeners();
    }
  }

  void unSelectAll() {
    if(!lock && isSelectable) {
      lock = true;
      isSelectionOn = false;

      selectedElements.forEach((element) => element.isSelected = false);
      selectedElements = new Set();

      lock = false;

      notifyListeners();
    }
  }

  void checkItem(AbstractModel item) async {
    if(item != null) {
      item.toggleCheck();
      notifyListeners();
    }
  }

  Future<void> doAction(SelectableItemSettingsEnum setting, context, [AbstractModel item]) async {
    if (isSelectable && isSelectionOn || item != null) {
      switch (setting) {
        case SelectableItemSettingsEnum.MODIFY:
        {
          await _modify(context, item);
        }
        break;
        case SelectableItemSettingsEnum.SHARE:
          {
            await _share(context, item);
          }
          break;
        case SelectableItemSettingsEnum.DELETE:
        {
          await _delete(context, item);
        }
        break;
        case SelectableItemSettingsEnum.REDIRECT_URL:
        {
          await _redirectUrl(context, item);
        }
        break;
      }

      isSelectionOn = false;
      unSelectAll();
    }
  }

  Future<void> _modify(context, [AbstractModel item]) async {
    item = item != null ? item : selectedElements.first;

    if (item != null) {
      Widget form;
      item = _convertToLower(item);

      if(item is Recipe) {
        form = RecipeFormScreen(recipeUuid: item.uuid, relatedModel: item.fromShoppingRecipe);
      } else if(item is Ingredient) {
        form = IngredientFormScreen(ingredientUuid: item.uuid, relatedModel: relatedModel);
      } else if(item is Instruction) {
        form = InstructionFormScreen(instructionUuid: item.uuid, relatedModel: relatedModel);
      } else if(item is ShoppingList) {
        form = ShoppingListFormScreen(shoppingListUuid: item.uuid);
      } else if(item is ShoppingItem) {
        form = ShoppingItemFormScreen(itemUuid: item.uuid, relatedModel: relatedModel);
      } else if(item is ShoppingRecipe) {
        form = ShoppingRecipeFormScreen(recipeUuid: item.uuid, relatedModel: relatedModel);
      }

      if(form != null) {
        Provider.of<NavigatorProvider>(context, listen: false).navigateTo(form, context);
      }
    }
  }

  Future<void> _share(context, [AbstractModel item]) async {
    item = item != null ? item : selectedElements.first;

    if (item != null) {
      String share;
      item = _convertToLower(item);

      if(item is Recipe) {
        share = _shareRecipe(context, item);
      } else if(item is ShoppingList) {
        share = _shareShoppingList(context, item);
      }

      if(share != null) {
        Provider.of<NavigatorProvider>(context, listen: false).shareContent(share);
      }
    }
  }

  String _shareRecipe(context, Recipe recipe) {
    List<String> sharable = List();

    sharable.add(SHARABLE_SEPARATOR);
    sharable.add(recipe.name);
    sharable.add(SHARABLE_SEPARATOR);
    sharable.add(SHARABLE_EMPTY_LINE);

    sharable.add(AppLocalizations.of(context).getMessage('ingredients.title') + SHARABLE_SECTION_TITLE_END);
    sharable.add(SHARABLE_EMPTY_LINE);

    recipe.ingredients.forEach((ingredient) =>
      sharable.add(SHARABLE_ITEM + ingredient.toString())
    );

    sharable.add(SHARABLE_EMPTY_LINE);
    sharable.add(AppLocalizations.of(context).getMessage('instructions.title') + SHARABLE_SECTION_TITLE_END);
    sharable.add(SHARABLE_EMPTY_LINE);

    recipe.instructions.forEach((instruction) {
      sharable.add(instruction.toString());
      sharable.add(SHARABLE_EMPTY_LINE);
    });

    return sharable.join(EOF);
  }

  String _shareShoppingList(context, ShoppingList list) {
    List<String> sharable = List();

    sharable.add(list.name);

    list.items.forEach((item) {
      if(!item.isEmpty()) {
        sharable.add(SHARABLE_ITEM + item.ingredient.toString());
      }
    });

    return sharable.join(EOF);
  }

  Future<void> _delete(context, [AbstractModel item]) async {
    List<AbstractModel> items = new List();
    bool isItem = item != null;

    if(isItem) {
      items.add(item);
    } else {
      items.addAll(selectedElements);
    }

    for(AbstractModel element in items) {
      element = _convertToUpper(element);
      CommonService service = modelToService(element);

      if(service != null) {
        await service.remove(element);
        removeItem(element);
      }
    }

    if(isItem) {
      Provider.of<NavigatorProvider>(context, listen: false)
          .navigateToPreviousScreenWithMessage(context);
    } else {
      Provider.of<NavigatorProvider>(context, listen: false)
          .showSnackBar(context);
    }

    notifyListeners();
  }

  Future<void> _redirectUrl(context, [AbstractModel item]) async {
    if(item != null && item is Recipe) {
      Recipe recipe = item;
      Provider.of<NavigatorProvider>(context, listen: false).launchUrl(recipe.url);
    }
  }

  AbstractModel _convertToUpper(AbstractModel item) {
    if(item is Recipe) {
      Recipe recipe = item;

      if(recipe.fromShoppingRecipe != null) {
        return recipe.fromShoppingRecipe;
      }
    } else if(item is Ingredient) {
     Ingredient ingredient = item;

      if(ingredient.fromShoppingItem != null) {
        return ingredient.fromShoppingItem;
      }
    }
    return item;
  }

  AbstractModel _convertToLower(AbstractModel item) {
    if(item is ShoppingRecipe) {
      ShoppingRecipe shoppingRecipe = item;

      return shoppingRecipe.recipe;
    } else if(item is ShoppingItem) {
      ShoppingItem shoppingItem = item;

      return shoppingItem.ingredient;
    }
    return item;
  }

  CommonService modelToService(AbstractModel item) {
    switch(CommonService.getModelType(item)) {
      case ModelTypeEnum.RECIPE:
        return serviceLocator.getService<RecipeService>();
      case ModelTypeEnum.INSTRUCTION:
        return serviceLocator.getService<InstructionService>();
      case ModelTypeEnum.INGREDIENT:
        return serviceLocator.getService<IngredientService>();
      case ModelTypeEnum.SHOPPING_LIST:
        return serviceLocator.getService<ShoppingListService>();
      case ModelTypeEnum.SHOPPING_ITEM:
        return serviceLocator.getService<ShoppingItemService>();
      case ModelTypeEnum.SHOPPING_RECIPE:
        return serviceLocator.getService<ShoppingRecipeService>();
      case ModelTypeEnum.NONE:
        return null;
    }
  }
}
