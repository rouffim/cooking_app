import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_item_form_provider.dart';
import 'package:cool_cooker/ui/utils/default_scaffold_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ShoppingItemFormScreen extends DefaultScaffoldScreen {
  final String itemUuid;
  final AbstractModel relatedModel;

  ShoppingItemFormScreen({this.itemUuid, this.relatedModel}): super(title: StringUtils.toFormTitle('shopping.item.form.title', itemUuid));

  @override
  Widget scaffoldBuild(BuildContext context) {
    context.read<ShoppingItemFormProvider>().setItem(itemUuid, this.relatedModel);

    return Consumer<ShoppingItemFormProvider>(
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
                        name: model.FIELD_NAME,
                        autofocus: true,
                        controller: model.getController(model.FIELD_NAME),
                        validator: model.shoppingItemNameValidator(context),
                        decoration: InputDecoration(
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
    return Consumer<ShoppingItemFormProvider>(builder: (context, model, child) {
      return FloatingActionButton(
        onPressed: () {
          model.submitForm(context);
        },
        child: Icon(Icons.check),
      );
    });
  }
}