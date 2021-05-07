import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/factory/api/recipe/ingredient_factory.dart';
import 'package:cool_cooker/core/model/factory/factory_locator_setup.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';

class ShoppingItem extends AbstractModel {
  Ingredient _ingredient;

  ShoppingItem() : super();

  ShoppingItem.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.checked = json['checked'] == 1;
    if(json['ingredient'] != null) {
      this.ingredient = this._ingredientFactory.transformOneFromJson(json['ingredient']);
    }
  }

  ShoppingItem.fromIngredient(Ingredient ingredient) : super() {
    _ingredient = ingredient;
    _ingredient.fromShoppingItem = this;
    checked = ingredient.checked;
  }


  Ingredient get ingredient => _ingredient;

  set ingredient(Ingredient value) {
    _ingredient = value;
    if(_ingredient != null) {
      _ingredient.fromShoppingItem = this;
      _ingredient.simpleChecked = checked;
    }
  }

  @override
  set checked(bool value) {
    super.checked = value;
    if(!this.isEmpty()) {
      ingredient.simpleChecked = value;
    }
  }

 IngredientFactory get _ingredientFactory {
    return factoryLocator.getFactory<IngredientFactory>();
  }


  @override
  bool isEmpty() {
    return _ingredient == null || _ingredient.isEmpty();
  }

  @override
  AbstractModel clone([AbstractModel toClone]) {
    ShoppingItem clone = new ShoppingItem();

    super.clone(clone);
    clone.ingredient = this.ingredient.clone() as Ingredient;

    return clone;
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    map['checked'] = checked ? 1 : 0;
    map['ingredient_id'] = isEmpty() ? null : ingredient.id;

    return map;
  }
}