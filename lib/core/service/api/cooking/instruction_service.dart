import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/persistence/api/cooking/instruction_persistence.dart';
import 'package:cool_cooker/core/service/api/common_fk_service.dart';

abstract class InstructionService extends CommonFkService<InstructionPersistence, Instruction> {

}