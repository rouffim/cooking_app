import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/ui/provider/cooking/ingredient_form_provider.dart';
import 'package:cool_cooker/ui/utils/default_scaffold_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class IngredientFormScreen extends DefaultScaffoldScreen {
  final String ingredientUuid;
  final AbstractModel relatedModel;

  IngredientFormScreen({this.ingredientUuid, this.relatedModel}): super(title: StringUtils.toFormTitle('ingredient.form.title', ingredientUuid));

  @override
  Widget scaffoldBuild(BuildContext context) {
    context.read<IngredientFormProvider>().setItem(ingredientUuid, relatedModel);

    return Consumer<IngredientFormProvider>(
        builder: (context, model, child) {
          return Center(
            child: !model.isReady ? ProgressContainerScreen() : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: FormBuilder(
                key: model.formKey,
                child: model.isModification() ?
                  _modifyForm(context, model, child) :
                  _newForm(context, model, child)
              )
            ),
          );
        }
    );
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return Consumer<IngredientFormProvider>(builder: (context, model, child) {
      return FloatingActionButton(
        onPressed: () {
          model.submitForm(context);
        },
        child: Icon(Icons.check),
      );
    });
  }

  Widget _newForm(context, model, child) {
    return ListView(
      children: <Widget>[
        _nameField(context, model, child),
      ],
    );
  }

  Widget _modifyForm(context, model, child) {
    return ListView(
      children: <Widget>[
        _nameField(context, model, child),
        FormBuilderTextField(
          name: model.FIELD_QUANTITY,
          controller: model.getController(model.FIELD_QUANTITY),
          keyboardType: TextInputType.number,
          validator: model.ingredientQuantityValidator(context),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).getMessage('ingredient.form.quantity.title'),
            hintText: AppLocalizations.of(context).getMessage('ingredient.form.quantity.hint'),
            suffixIcon: IconButton(
              onPressed: () => model.deleteField(model.FIELD_QUANTITY),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        FormBuilderTextField(
          name: model.FIELD_MAX_QUANTITY,
          controller: model.getController(model.FIELD_MAX_QUANTITY),
          keyboardType: TextInputType.number,
          validator: (val) {
            return model.ingredientMaxQuantityValidator(context);
          },
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).getMessage('ingredient.form.max_quantity.title'),
            hintText: AppLocalizations.of(context).getMessage('ingredient.form.max_quantity.hint'),
            suffixIcon: IconButton(
              onPressed: () => model.deleteField(model.FIELD_MAX_QUANTITY),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        FormBuilderTextField(
          name: model.FIELD_QUANTITY_UNITE,
          controller: model.getController(model.FIELD_QUANTITY_UNITE),
          validator: model.ingredientQuantityUniteValidator(context),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).getMessage('ingredient.form.quantity_unite.title'),
            hintText: AppLocalizations.of(context).getMessage('ingredient.form.quantity_unite.hint'),
            suffixIcon: IconButton(
              onPressed: () => model.deleteField(model.FIELD_QUANTITY_UNITE),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
      ],
    );
  }

  Widget _nameField(context, IngredientFormProvider model, child) {
    return FormBuilderTextField(
      name: model.FIELD_NAME,
      controller: model.getController(model.FIELD_NAME),
      validator: model.ingredientNameValidator(context),
      decoration: InputDecoration(
        labelText: model.isModification() ? AppLocalizations.of(context)
            .getMessage('ingredient.form.name.title') : null,
        hintText: AppLocalizations.of(context)
            .getMessage(model.isModification() ? 'ingredient.form.name.hint' : 'ingredient.form.name.new.hint'),
        suffixIcon: IconButton(
          onPressed: () => model.deleteField(model.FIELD_NAME),
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }
}