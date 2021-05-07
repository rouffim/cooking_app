import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_form_provider.dart';
import 'package:cool_cooker/ui/utils/default_scaffold_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ShoppingListFormScreen extends DefaultScaffoldScreen {
  final String shoppingListUuid;

  ShoppingListFormScreen({this.shoppingListUuid}) : super(title: StringUtils.toFormTitle('shopping_list.form.title', shoppingListUuid));

  @override
  Widget scaffoldBuild(BuildContext context) {
    context.read<ShoppingListFormProvider>().setItem(shoppingListUuid);

    return Consumer<ShoppingListFormProvider>(builder: (context, model, child) {
      return Center(
        child: !model.isReady ? ProgressContainerScreen() : Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: FormBuilder(
              key: model.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FormBuilderTextField(
                    name: model.FIELD_NAME,
                    autofocus: true,
                    controller: model.getController(model.FIELD_NAME),
                    validator: model.shoppingListNameValidator(context),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () => model.deleteField(model.FIELD_NAME),
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      );
    });
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return Consumer<ShoppingListFormProvider>(builder: (context, model, child) {
      return FloatingActionButton(
        onPressed: () {
          model.submitForm(context);
        },
        child: Icon(Icons.check),
      );
    });
  }
}
