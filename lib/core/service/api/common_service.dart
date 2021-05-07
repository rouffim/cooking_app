import 'package:connectivity/connectivity.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/exception/no_connexion_exception.dart';
import 'package:cool_cooker/core/model/model_type_enum.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/model/shopping/shopping_item.dart';
import 'package:cool_cooker/core/model/shopping/shopping_list.dart';
import 'package:cool_cooker/core/model/shopping/shopping_recipe.dart';
import 'package:cool_cooker/core/persistence/api/common_persistence.dart';
import 'package:cool_cooker/core/persistence/persistence_locator_setup.dart';

abstract class CommonService<S extends CommonPersistence, T extends AbstractModel> {

  Future<T> findOne(String uuid) async {
    return persistence.findOne(uuid);
  }
  
  Future<void> remove(T element) async {
    return persistence.remove(element);
  }
  
  Future<void> removeAll() async {
    return persistence.removeAll();
  }

  static ModelTypeEnum getModelType(AbstractModel model) {
    if(model is Recipe) {
      return ModelTypeEnum.RECIPE;
    }
    if(model is Ingredient) {
      return ModelTypeEnum.INGREDIENT;
    }
    if(model is Instruction) {
      return ModelTypeEnum.INSTRUCTION;
    }
    if(model is ShoppingList) {
      return ModelTypeEnum.SHOPPING_LIST;
    }
    if(model is ShoppingItem) {
      return ModelTypeEnum.SHOPPING_ITEM;
    }
    if(model is ShoppingRecipe) {
      return ModelTypeEnum.SHOPPING_RECIPE;
    }
    return ModelTypeEnum.NONE;
  }


  S get persistence {
    return persistenceLocator.getPersistence<S>();
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult == ConnectivityResult.none) {
      throw new NoConnexionException();
    }

    return true;
  }

}