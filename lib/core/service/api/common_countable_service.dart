import 'package:cool_cooker/core/model/abstract_countable_model.dart';
import 'package:cool_cooker/core/model/app_sorting.dart';
import 'package:cool_cooker/core/persistence/api/common_countable_persistence.dart';
import 'package:cool_cooker/core/service/api/common_service.dart';

abstract class CommonCountableService<S extends CommonCountablePersistence, T extends AbstractCountableModel> extends CommonService<S, T> {

  Future<List<T>> find(String term, [int from, int to, SortEnum sort]) async {
    return persistence.find(term, from, to, sort);
  }

  Future<List<T>> findAll([int from, int to, SortEnum sort]) async {
    return persistence.findAll(from, to, sort);
  }

  Future<bool> save(T countable) async {
    return persistence.save(countable);
  }
}