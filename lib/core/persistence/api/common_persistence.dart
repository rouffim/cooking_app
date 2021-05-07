import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/factory/api/common_factory.dart';
import 'package:cool_cooker/core/model/factory/factory_locator_setup.dart';
import 'package:cool_cooker/core/persistence/api/sql_lite_persistence.dart';
import 'package:cool_cooker/core/persistence/persistence_locator_setup.dart';

abstract class CommonPersistence<S extends CommonFactory, T extends AbstractModel> {
  final String TABLE_NAME;

  CommonPersistence(this.TABLE_NAME);


  Future<T> findOne(String uuid);
  
  Future<void> remove(T record) async {
    sqlLitePersistence.delete(TABLE_NAME, record.uuid);
  }
  
  Future<void> removeAll() async {
    sqlLitePersistence.deleteAll(TABLE_NAME);
  }

  
  SqlLitePersistence get sqlLitePersistence {
    return persistenceLocator.getPersistence<SqlLitePersistence>();
  }

  S get factory {
    return factoryLocator.getFactory<S>();
  }

}