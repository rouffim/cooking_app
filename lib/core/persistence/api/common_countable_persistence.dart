import 'package:cool_cooker/core/model/abstract_countable_model.dart';
import 'package:cool_cooker/core/model/app_sorting.dart';
import 'package:cool_cooker/core/model/factory/api/common_factory.dart';
import 'package:cool_cooker/core/persistence/api/common_persistence.dart';

abstract class CommonCountablePersistence<S extends CommonFactory, T extends AbstractCountableModel> extends CommonPersistence<S, T> {

  CommonCountablePersistence(tableName): super(tableName);

  Future<bool> save(T countable);

  Future<List<T>> find(String term, [int from, int to, SortEnum sort]) async {
    List<T> records = new List();
    List<Map> results = await sqlLitePersistence.selectAllByName(TABLE_NAME, term, from, to, sort);

    if(results.isNotEmpty) {
      records = factory.transformListFromJson(results);
    }

    return records;
  }

  Future<List<T>> findAll([int from, int to, SortEnum sort]) async {
    List<T> records = new List();
    List<Map> results = await sqlLitePersistence.selectAll(TABLE_NAME, from: from, to: to, sort: sort);

    if(results.isNotEmpty) {
      records = factory.transformListFromJson(results);
    }

    return records;
  }
}