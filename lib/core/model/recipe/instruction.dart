import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/abstract_named_model.dart';

class Instruction extends AbstractNamedModel {
  bool _checked = false;
  int _order;

  Instruction() : super();

  Instruction.name(String name) : super.name(name);

  Instruction.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this._checked = json['checked'] == 1;
    this.order = json['instruction_order'];
  }


  bool get checked => _checked;

  set checked(bool value) {
    _checked = value;
  }

  void toggleCheck() {
    this.checked = !checked;
  }

  int get order {
    return _order;
  }
  set order(int order) {
    if(order != null && order < 0) {
      print("order should be greater than 0");
    }  else {
      this._order = order;
    }
  }


  String toString() {
    return (order != null ? "$order.   " : "") + name;
  }

  @override
  AbstractModel clone([AbstractModel toClone]) {
    Instruction clone = new Instruction();

    super.clone(clone);
    clone.name = this.name;
    clone.checked = this.checked;
    clone.order = this.order;

    return clone;
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    map['checked'] = checked ? 1 : 0;
    map['instruction_order'] = order;

    return map;
  }
}