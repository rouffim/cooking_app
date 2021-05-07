import 'package:cool_cooker/core/model/factory/api/recipe/instruction_factory.dart';
import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/persistence/api/common_fk_persistence.dart';

abstract class InstructionPersistence extends CommonFkPersistence<InstructionFactory, Instruction> {
  InstructionPersistence() : super('instruction', 'recipe_id');
}