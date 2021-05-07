import 'package:cool_cooker/core/model/abstract_countable_model.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/factory/api/common_factory.dart';
import 'package:cool_cooker/core/persistence/api/common_persistence.dart';

abstract class CommonFkPersistence<S extends CommonFactory, T extends AbstractModel> extends CommonPersistence<S, T> {
  final String FK_NAME;

  CommonFkPersistence(tableName, this.FK_NAME): super(tableName);

  @override
  Future<T> findOne(String uuid) async {
    T record;
    Map result = await sqlLitePersistence.selectByUuid(TABLE_NAME, uuid);

    if(result != null) {
      record = factory.transformOneFromJson(result);
    }

    return record;
  }

  Future<List<T>> findAllByFk(int fkId) async {
    List<T> records = new List();
    List<Map> results = await sqlLitePersistence.selectAll(TABLE_NAME, fkId: fkId, fkKey: FK_NAME);

    if(results.isNotEmpty) {
      records = factory.transformListFromJson(results);
    }

    return records;
  }

  Future<bool> save(T record, AbstractCountableModel countable) async {
    Map recordMap = record.toMap();
    recordMap[FK_NAME] = countable.id;

    try {
      sqlLitePersistence.save(TABLE_NAME, recordMap);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> saveAll(List<T> records, AbstractCountableModel countable) async {
    if(records != null) {
      for(T record in records) {
        if(!(await save(record, countable))) {
          return false;
        }
      }
    }
    return true;
  }
}