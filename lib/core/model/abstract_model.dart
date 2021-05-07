import 'package:cool_cooker/utils/string_utils.dart';
import 'package:cool_cooker/utils/uuid_utils.dart';

abstract class AbstractModel {
  int _id;
  String _uuid;
  DateTime _creationDate;
  DateTime _lastModificationDate;
  bool _checked = false;
  bool isSelected = false;

  AbstractModel() {
    this._id = null;
    this._creationDate = new DateTime.now();
    this._lastModificationDate = this._creationDate;
    this._uuid = UuidUtils.generateUuid();
  }

  AbstractModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.uuid = json['uuid'];
    this.creationDateFromString = json['creation_date'];
    this.lastModificationDateFromString = json['last_modification_date'];
  }

  int get id {
    return _id;
  }
  set id(int id) {
    this._id = id;
  }

  String get uuid {
    return _uuid;
  }
  set uuid(String uuid) {
    if(StringUtils.isNotBlank(uuid)) {
      this._uuid = uuid;
    }
  }

  DateTime get creationDate {
    if(_creationDate == null) {
      return _creationDate = new DateTime.now();
    }
    return _creationDate;
  }
  set creationDate(DateTime value) {
    _creationDate = value;
  }
  set creationDateFromString(String value) {
    if(value != null) {
      _creationDate = DateTime.parse(value);
    }
  }

  DateTime get lastModificationDate {
    if(_lastModificationDate == null) {
      return _lastModificationDate = this.creationDate;
    }
    return _lastModificationDate;
  }
  set lastModificationDate(DateTime value) {
    _lastModificationDate = value;
  }
  set lastModificationDateFromString(String value) {
    if(value != null) {
      _lastModificationDate = DateTime.parse(value);
    }
  }


  bool get checked => _checked;

  set checked(bool value) {
    _checked = value;
  }

  set simpleChecked(bool value) {
    _checked = value;
  }

  void toggleCheck() {
    this.checked = !checked;
  }

  bool isEmpty() {
    return StringUtils.isBlank(this.uuid);
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'creation_date': creationDate.toIso8601String(),
      'last_modification_date': new DateTime.now().toIso8601String(),
    };
  }

  AbstractModel clone([AbstractModel toClone]) {
    if(toClone != null) {
      toClone.uuid = this.uuid;
      toClone.creationDate = this.creationDate;
      toClone.lastModificationDate = this.lastModificationDate;
      toClone.checked = this.checked;
      toClone.isSelected = this.isSelected;
    }

    return toClone;
  }

  @override
  int get hashCode {
    return uuid.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return this.hashCode == other.hashCode;
  }

  @override
  String toString() {
    return 'AbstractModel{_uuid: $_uuid}';
  }
}