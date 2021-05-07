import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/abstract_named_model.dart';
import 'package:cool_cooker/core/model/shopping/shopping_item.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class Ingredient extends AbstractNamedModel {
  double _quantity;
  double _modifiedQuantity;
  double _maxQuantity;
  double _modifiedMaxQuantity;
  String _quantityUnite;
  ShoppingItem fromShoppingItem;

  Ingredient() : super();

  Ingredient.name(String name) : super.name(name);

  Ingredient.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this._quantity = NumberUtils.parseDouble(json['quantity']);
    this.maxQuantity = NumberUtils.parseDouble(json['max_quantity']);
    this.quantityUnite = json['quantity_unite'];
  }


  double get quantity {
    return _quantity;
  }
  set quantity(double quantity) {
    if(quantity != null && quantity <= 0) {
      print("quantity should be greater than 0");
    }  else {
      this._quantity = quantity;
      _modifiedQuantity = quantity;
    }
  }


  double get modifiedQuantity {
    if(this._modifiedQuantity == null) {
      this._modifiedQuantity = this.quantity;
    }
    return _modifiedQuantity;
  }
  set modifiedQuantity(double modifiedQuantity) {
    if(modifiedQuantity != null && modifiedQuantity <= 0) {
      print("modifiedQuantity should be greater than 0");
    }  else {
      this._modifiedQuantity = modifiedQuantity;
    }
  }

  double get maxQuantity {
    return _maxQuantity;
  }
  set maxQuantity(double maxQuantity) {
    if(maxQuantity != null && this.quantity != null && maxQuantity <= this.quantity) {
      print("maxQuantity should be greater than the ingredient quantity");
    }  else {
      this._maxQuantity = maxQuantity;
      this._modifiedMaxQuantity = maxQuantity;
    }
  }

  double get modifiedMaxQuantity {
    if(this._modifiedMaxQuantity == null) {
      this._modifiedMaxQuantity = this.maxQuantity;
    }
    return _modifiedMaxQuantity;
  }
  set modifiedMaxQuantity(double modifiedMaxQuantity) {
    if(modifiedMaxQuantity != null && this.modifiedQuantity != null && modifiedMaxQuantity <= this.modifiedQuantity) {
      print("modifiedMaxQuantity should be greater than the ingredient modifiedQuantity");
    }  else {
      this._modifiedMaxQuantity = modifiedMaxQuantity;
    }
  }

  String get quantityUnite {
    return _quantityUnite;
  }
  set quantityUnite(String quantityUnite) {
    this._quantityUnite = quantityUnite;
  }

  @override
  set checked(bool value) {
    simpleChecked = value;
    if(fromShoppingItem != null) {
      fromShoppingItem.simpleChecked = value;
    }
  }
  

  String displayQuantity() {
    if(this.quantity != null && StringUtils.isNotBlank(this.quantityUnite)) {
      String max = this.maxQuantity != null ? ' à ' + NumberUtils.removeDecimalZeroFormat(this.modifiedMaxQuantity) + ' ' + this.quantityUnite + ' ' : '';
      return NumberUtils.removeDecimalZeroFormat(this.modifiedQuantity) + ' ' + this.quantityUnite + max;
    } else if(this.quantity != null) {
      return NumberUtils.removeDecimalZeroFormat(this.modifiedQuantity);
    }
    return '';
  }

  String toString() {
    return this.displayQuantity() + ' ' + this.name;
  }

  @override
  AbstractModel clone([AbstractModel toClone]) {
    Ingredient clone = new Ingredient();

    super.clone(clone);
    clone.quantity = this.quantity;
    clone.maxQuantity = this.maxQuantity;
    clone.quantityUnite = this.quantityUnite;

    return clone;
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    map['quantity'] = quantity;
    map['max_quantity'] = maxQuantity;
    map['quantity_unite'] = quantityUnite;

    return map;
  }
}