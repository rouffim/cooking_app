import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/service/api/cooking/instruction_service.dart';
import 'package:cool_cooker/ui/provider/common_form_provider.dart';
import 'package:cool_cooker/ui/provider/cooking/recipe_provider.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class InstructionFormProvider extends CommonFormProvider<InstructionService, Instruction> {
  final  String FIELD_NAME = 'instruction_name';
  final  String FIELD_ORDER = 'instruction_order';

  InstructionFormProvider() {
    addController(FIELD_NAME);
    addController(FIELD_ORDER);
  }

  @override
  void initForm() {
    if(formItem != null) {
      getController(FIELD_NAME).text = formItem.name;
      getController(FIELD_ORDER).text = NumberUtils.intToString(formItem.order);
    } else {
      deleteField(FIELD_NAME);

      if(relatedFkFormItem != null && relatedFkFormItem is Recipe) {
        Recipe recipe = relatedFkFormItem;
        getController(FIELD_ORDER).text = (recipe.instructions.length + 1).toString();
      }
    }
  }

  @override
  Future<Instruction> submitForm(BuildContext context) async {
    Instruction instruction;
    setNotReady();
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (formKey.currentState.validate()) {
      try{
        // If the form is valid
        instruction = isModification() ? formItem : new Instruction();
        instruction.name = getController(FIELD_NAME).text;
        instruction.order = int.tryParse(getController(FIELD_ORDER).text);

        if(await service.save(instruction, relatedFkFormItem)) {
          if(relatedFkFormItem is Recipe) {
            Provider.of<RecipeProvider>(context, listen: false).addInstruction(
                instruction, relatedFkFormItem);
          } else {
            throw Exception();
          }
          Provider.of<NavigatorProvider>(context, listen: false).navigateToPreviousScreenWithMessage(context);
        } else {
          throw Exception();
        }
      } catch(exception) {
        print(exception);
        Provider.of<NavigatorProvider>(context, listen: false)
            .navigateToPreviousScreenWithErrorMessage(context);
      }
    }

    setReady();
    return instruction;
  }

  // Form validations
  
  FormFieldValidator<String> instructionNameValidator(context) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(context),
    ]);
  }

  FormFieldValidator<String> instructionOrderValidator(context) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.integer(context),
    ]);
  }
}