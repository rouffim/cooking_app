import 'dart:collection';

import 'package:cool_cooker/core/model/abstract_countable_model.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/app_sorting.dart';
import 'package:cool_cooker/core/service/api/common_countable_service.dart';
import 'package:cool_cooker/core/service/service_locator_setup.dart';
import 'package:cool_cooker/ui/provider/selectable_provider.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/cupertino.dart';

abstract class CommonProvider<S extends CommonCountableService, T extends AbstractCountableModel> extends SelectableProvider {
  int from;
  int step = 10;
  bool fullyLoaded = false;

  String _currentSearchTerm;
  SortEnum _currentSort = SortEnum.MODIFICATION_DATE_DESC;

  bool isReady = false;
  TextEditingController searchController = TextEditingController();

  final List<T> _elements = new List();
  UnmodifiableListView<T> get elements => UnmodifiableListView(_elements);

  CommonCountableService service = serviceLocator.getService<S>();

  CommonProvider() {
    initData();
  }

  Future<void> initData() async {
    isReady = false;
    fullyLoaded = false;
    notifyListeners();
    from = 0;
    _elements.clear();
    await _loadData();
    isReady = true;
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    if(!fullyLoaded && _elements.length >= from + step) {
      from += step;
      await _loadData();
      notifyListeners();
    }
  }

  Future<void> _loadData() async {
    List<T> loaded = StringUtils.isBlank(_currentSearchTerm) ?
      await service.findAll(from, from + step, _currentSort) :
      await service.find(_currentSearchTerm, from, from + step, _currentSort);

    if(loaded.length < step) {
      fullyLoaded = true;
    }
    _elements.addAll(loaded);
  }


  T getElement(int index) {
    T element;

    if(_elements.length > index) {
      element = _elements.elementAt(index);
    }

    return element;
  }

  @override
  void removeItem(AbstractModel element) {
    _elements.remove(element);
  }

  Future<void> save(T element, [bool notify = true]) async {
    if(await service.save(element)) {
      _currentSearchTerm = null;
      _currentSort = SortEnum.MODIFICATION_DATE_DESC;
      await initData();

      if (notify)
        notifyListeners();
    } else {
      throw Exception();
    }
  }

  Future<void> remove(T element, [bool notify = false]) async {
    await service.remove(element);
    removeItem(element);

    if(notify)
      notifyListeners();
  }

  Future<void> removeAll([bool notify = true]) async {
    await service.removeAll();
    _elements.clear();

    if(notify)
      notifyListeners();
  }

  void search([String term]) {
    term = StringUtils.isBlank(term) ?
        searchController.text :
        term;
    this._currentSearchTerm = term;
    initData();
  }

  void sortList(SortEnum sort) {
    this._currentSort = sort;
    initData();
  }

  Future<void> clearSearchBar() async {
    searchController.clear();
    _currentSearchTerm = null;
    await initData();
    notifyListeners();
  }

}