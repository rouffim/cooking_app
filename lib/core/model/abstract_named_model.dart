import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/utils/string_utils.dart';

abstract class AbstractNamedModel extends AbstractModel {
  String _name;

  AbstractNamedModel() : this.name('');

  AbstractNamedModel.name(String name) : super() {
    this._name = name;
  }

  AbstractNamedModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.name = json['name'];
  }

  String get name {
    return _name;
  }
  set name(String name) {
    this._name = name;
  }


  @override
  bool isEmpty() {
    return super.isEmpty() || StringUtils.isBlank(this.name);
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    map['name'] = name;

    return map;
  }

  @override
  AbstractModel clone([AbstractModel toClone]) {
    if(toClone != null && toClone is AbstractNamedModel) {
      super.clone(toClone);
      toClone.name = this.name;
    }

    return toClone;
  }

  @override
  String toString() {
    return 'AbstractNamedModel{_uuid: $uuid, _name: $_name}';
  }
}