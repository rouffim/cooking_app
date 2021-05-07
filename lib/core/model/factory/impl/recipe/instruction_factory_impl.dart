import 'dart:convert';

import 'package:cool_cooker/core/model/factory/api/recipe/instruction_factory.dart';
import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class InstructionFactoryImpl extends InstructionFactory {

  @override
  Instruction transformOneFromJson(json) {
    return Instruction.fromJson(StringUtils.isString(json) ? jsonDecode(json) : json);
  }

}