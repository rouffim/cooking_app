import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/factory/api/common_factory.dart';
import 'package:cool_cooker/core/persistence/api/common_fk_persistence.dart';

abstract class CommonFksPersistence<S extends CommonFactory, T extends AbstractModel> extends CommonFkPersistence<S, T> {
  final String SECOND_FK_NAME;

  CommonFksPersistence(tableName, fkName, this.SECOND_FK_NAME): super(tableName, fkName);

  @override
  Future<T> findOne(String uuid) async {
    T record;
    Map result = await sqlLitePersistence.selectByUuid(TABLE_NAME, uuid);

    if(result != null) {
      result[SECOND_FK_NAME] = await sqlLitePersistence.selectById(SECOND_FK_NAME, result[SECOND_FK_NAME + "_id"]);
      record = factory.transformOneFromJson(result);
    }

    return record;
  }

  @override
  Future<List<T>> findAllByFk(int fkId) async {
    List<T> records = new List();
    List<Map> results = await sqlLitePersistence.selectAll(TABLE_NAME, fkId: fkId, fkKey: FK_NAME);

    if(results.isNotEmpty) {
      for(Map result in results) {
        Map<String, dynamic> r = Map.of(result);
        r[SECOND_FK_NAME] = await sqlLitePersistence.selectById(SECOND_FK_NAME, result[SECOND_FK_NAME + "_id"]);
        records.add(factory.transformOneFromJson(r));
      }
    }

    return records;
  }
}