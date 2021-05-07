import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/persistence/api/cooking/ingredient_persistence.dart';
import 'package:cool_cooker/core/persistence/api/cooking/instruction_persistence.dart';
import 'package:cool_cooker/core/persistence/api/cooking/recipe_persistence.dart';
import 'package:cool_cooker/core/persistence/persistence_locator_setup.dart';

class RecipePersistenceImpl extends RecipePersistence {

  @override
  Future<Recipe> findOne(String uuid) async {
    Recipe recipe;
    Map result = await sqlLitePersistence.selectByUuid(TABLE_NAME, uuid);

    if(result != null) {
      recipe = factory.transformOneFromJson(result);
      recipe.ingredients = await _ingredientPersistence.findAllByFk(recipe.id);
      recipe.instructions = await _instructionPersistence.findAllByFk(recipe.id);
    }

    return recipe;
  }

  @override
  Future<bool> save(Recipe recipe) async {
    if(recipe != null && !recipe.isEmpty()) {
      recipe.id = await sqlLitePersistence.save(TABLE_NAME, recipe.toMap());
      await _ingredientPersistence.saveAll(recipe.ingredients, recipe);
      await _instructionPersistence.saveAll(recipe.instructions, recipe);
      return true;
    }
    return false;
  }


  IngredientPersistence get _ingredientPersistence {
    return persistenceLocator.getPersistence<IngredientPersistence>();
  }

  InstructionPersistence get _instructionPersistence {
    return persistenceLocator.getPersistence<InstructionPersistence>();
  }
}