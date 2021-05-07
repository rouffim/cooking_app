import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/factory/api/recipe/recipe_factory.dart';
import 'package:cool_cooker/core/model/factory/factory_locator_setup.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';

class ShoppingRecipe extends AbstractModel {
  Recipe _recipe;

  ShoppingRecipe() : super();

  ShoppingRecipe.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if(json['recipe'] != null) {
      this.recipe = this._recipeFactory.transformOneFromJson(json['recipe']);
    }
  }


  Recipe get recipe => _recipe;

  set recipe(Recipe value) {
    _recipe = value;
    _recipe.fromShoppingRecipe = this;
  }

  RecipeFactory get _recipeFactory {
    return factoryLocator.getFactory<RecipeFactory>();
  }

  @override
  bool isEmpty() {
    return recipe == null || recipe.isEmpty();
  }

  @override
  AbstractModel clone([AbstractModel toClone]) {
    ShoppingRecipe clone = new ShoppingRecipe();

    super.clone(clone);
    clone.recipe = this.recipe.clone() as Recipe;

    return clone;
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    map['recipe_id'] = isEmpty() ? null : recipe.id;

    return map;
  }
}