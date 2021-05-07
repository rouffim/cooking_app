import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/ui/provider/cooking/instruction_form_provider.dart';
import 'package:cool_cooker/ui/utils/default_scaffold_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class InstructionFormScreen extends DefaultScaffoldScreen {
  final String instructionUuid;
  final AbstractModel relatedModel;

  InstructionFormScreen({this.instructionUuid, this.relatedModel}): super(title: StringUtils.toFormTitle('instruction.form.title', instructionUuid));

  @override
  Widget scaffoldBuild(BuildContext context) {
    context.read<InstructionFormProvider>().setItem(instructionUuid, this.relatedModel);

    return Consumer<InstructionFormProvider>(
        builder: (context, model, child) {
          return Center(
            child: !model.isReady ? ProgressContainerScreen() : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: FormBuilder(
                  key: model.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FormBuilderTextField(
                        name: model.FIELD_ORDER,
                        controller: model.getController(model.FIELD_ORDER),
                        keyboardType: TextInputType.number,
                        validator: model.instructionOrderValidator(context),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).getMessage('instruction.form.order.title'),
                          hintText: AppLocalizations.of(context).getMessage('instruction.form.order.hint'),
                          suffixIcon: IconButton(
                            onPressed: () => model.deleteField(model.FIELD_ORDER),
                            icon: Icon(Icons.clear),
                          ),
                        ),
                      ),
                      FormBuilderTextField(
                        name: model.FIELD_NAME,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autofocus: true,
                        controller: model.getController(model.FIELD_NAME),
                        validator: model.instructionNameValidator(context),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).getMessage('instruction.form.name.title'),
                          hintText: AppLocalizations.of(context).getMessage('instruction.form.name.hint'),
                          suffixIcon: IconButton(
                            onPressed: () => model.deleteField(model.FIELD_NAME),
                            icon: Icon(Icons.clear),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          );
        }
    );
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return Consumer<InstructionFormProvider>(builder: (context, model, child) {
      return FloatingActionButton(
        onPressed: () {
          model.submitForm(context);
        },
        child: Icon(Icons.check),
      );
    });
  }
}