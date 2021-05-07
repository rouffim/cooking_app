import 'package:cool_cooker/core/model/abstract_model.dart';

import 'abstract_named_model.dart';

class AbstractCountableModel extends AbstractNamedModel {
  DateTime _lastViewedDate;
  int _nbTimesViewed;
  bool _isFavorite = false;

  AbstractCountableModel() : super() {
    this._nbTimesViewed = 0;
  }

  AbstractCountableModel.name(String name) : super.name(name);

  AbstractCountableModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.isFavorite = json['is_favorite'] == 1;
    this.lastViewedDateFromString = json['last_viewed_date'];
    this.nbTimesViewed = json['views'];
  }


  DateTime get lastViewedDate {
    if(_lastViewedDate == null) {
      return _lastViewedDate = new DateTime.now();
    }
    return _lastViewedDate;
  }
  set lastViewedDate(DateTime value) {
    _lastViewedDate = value;
  }
  set lastViewedDateFromString(String value) {
    if(value != null) {
      _lastViewedDate = DateTime.parse(value);
    }
  }

  int get nbTimesViewed {
    if(_nbTimesViewed == null) {
      _nbTimesViewed = 0;
    }
    return _nbTimesViewed;
  }
  set nbTimesViewed(int value) {
    _nbTimesViewed = value;
  }

  bool get isFavorite => _isFavorite;
  set isFavorite(bool value) {
    _isFavorite = value;
  }

  void addView() {
    nbTimesViewed = nbTimesViewed + 1;
    lastViewedDate = new DateTime.now();
  }


  @override
  AbstractModel clone([AbstractModel toClone]) {
    if(toClone != null && toClone is AbstractCountableModel) {
      super.clone(toClone);
      toClone.lastViewedDate = this.lastViewedDate;
      toClone.nbTimesViewed = this.nbTimesViewed;
      toClone.isFavorite = this.isFavorite;
    }

    return toClone;
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    map['last_viewed_date'] = lastViewedDate != null ? lastViewedDate.toIso8601String() : null;
    map['views'] = nbTimesViewed;
    map['is_favorite'] = isFavorite ? 1 : 0;

    return map;
  }
}
