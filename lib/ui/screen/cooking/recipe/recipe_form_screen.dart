import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/ui/provider/cooking/recipe_form_provider.dart';
import 'package:cool_cooker/ui/utils/default_scaffold_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class RecipeFormScreen extends DefaultScaffoldScreen {
  final String recipeUuid;
  final AbstractModel relatedModel;

  RecipeFormScreen({this.recipeUuid, this.relatedModel}) : super(title: StringUtils.toFormTitle('recipe.form.title', recipeUuid));

  @override
  Widget scaffoldBuild(BuildContext context) {
    context.read<RecipeFormProvider>().setItem(recipeUuid, relatedModel);

    return Consumer<RecipeFormProvider>(builder: (context, model, child) {
      return !model.isReady ? ProgressContainerScreen() : Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: FormBuilder(
              key: model.formKey,
              child: model.isModification() ?
                _modifyForm(context, model, child) :
                _newForm(context, model, child)
            )
      );
    });
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return Consumer<RecipeFormProvider>(builder: (context, model, child) {
      return FloatingActionButton(
        onPressed: () {
          model.submitForm(context);
        },
        child: Icon(Icons.check),
      );
    });
  }

  Widget _newForm(context, RecipeFormProvider model, child) {
    return ListView(
      children: <Widget>[
        _fromWeb(context, model, child),
        _formSeparator(context, model, child),
        _fromYours(context, model, child),
      ],
    );
  }

  Widget _modifyForm(context, RecipeFormProvider model, child) {
    return ListView(
      children: <Widget>[
        _nameField(context, model, child),
        _nbPersonsField(context, model, child),
        _urlField(context, model, child),
      ],
    );
  }

  Widget _fromWeb(context, RecipeFormProvider model, child) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              AppLocalizations.of(context).getMessage('recipe.form.head1'),
              style: TextStyle(
                  fontSize: 22
              )
          ),
          _urlField(context, model, child),
        ],
    );
  }

  Widget _fromYours(context, RecipeFormProvider model, child) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                AppLocalizations.of(context).getMessage('recipe.form.head2'),
                style: TextStyle(
                    fontSize: 22
                )
            ),
            _nameField(context, model, child),
            _nbPersonsField(context, model, child)
          ],
        )
    );
  }

  Widget _formSeparator(context, RecipeFormProvider model, child) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.white,
                height: 4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                  AppLocalizations.of(context).getMessage('recipe.form.separator.title'),
                  style: TextStyle(
                      fontSize: 18
                  )
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.white,
                height: 4,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _nameField(context, RecipeFormProvider model, child) {
    return FormBuilderTextField(
      name: model.FIELD_NAME,
      controller: model.getController(model.FIELD_NAME),
      validator: (val) {
        return model.recipeNameValidator(context);
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).getMessage('recipe.form.name.title'),
        hintText: AppLocalizations.of(context).getMessage('recipe.form.name.hint'),
        suffixIcon: IconButton(
          onPressed: () => model.deleteField(model.FIELD_NAME),
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }

  Widget _urlField(context, RecipeFormProvider model, child) {
    return Column(
      children: [
        FormBuilderTextField(
          name: model.FIELD_URL,
          keyboardType: TextInputType.url,
          controller: model.getController(model.FIELD_URL),
          validator: (val) {
            return model.recipeUrlValidator(context);
          },
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).getMessage('recipe.form.url.title'),
            hintText: AppLocalizations.of(context).getMessage('recipe.form.url.hint'),
            suffixIcon: IconButton(
              onPressed: () => model.deleteField(model.FIELD_URL),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextButton(
                  onPressed: () async {
                    model.pasteUrl();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.paste),
                      Text(AppLocalizations.of(context).getMessage('recipe.form.url.paste')),
                    ],
                  )),
            ),
          ],
        ),
      ]
    );
  }

  Widget _nbPersonsField(context, RecipeFormProvider model, child) {
    return FormBuilderTextField(
      name: model.FIELD_NB_PERSONS,
      controller: model.getController(model.FIELD_NB_PERSONS),
      keyboardType: TextInputType.number,
      validator: model.recipeNbPersonsValidator(context),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).getMessage('recipe.form.nb_persons.title'),
        hintText: AppLocalizations.of(context).getMessage('recipe.form.nb_persons.hint'),
        suffixIcon: IconButton(
          onPressed: () => model.deleteField(model.FIELD_NB_PERSONS),
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }
}
