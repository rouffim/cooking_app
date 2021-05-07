import 'package:cool_cooker/core/model/abstract_countable_model.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/persistence/api/common_fk_persistence.dart';
import 'package:cool_cooker/core/service/api/common_service.dart';

abstract class CommonFkService<S extends CommonFkPersistence, T extends AbstractModel> extends CommonService<S, T> {

  Future<bool> save(T element, AbstractCountableModel countable) async {
    return persistence.save(element, countable);
  }

}