import 'package:cool_cooker/core/model/abstract_countable_model.dart';
import 'package:cool_cooker/ui/enums/selectable_item_settings_enum.dart';
import 'package:cool_cooker/ui/utils/countable_menu_item_screen.dart';
import 'package:flutter/material.dart';

class CountableMenuScreen<T extends AbstractCountableModel> extends StatelessWidget {
  final Function callback;
  final T item;
  final bool withRedirectUrl;

  CountableMenuScreen(this.callback, this.item, [this.withRedirectUrl = false]);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SelectableItemSettingsEnum>(
        itemBuilder: (BuildContext bc) =>
        [
          countableMenuItemScreen(
            context,
            'general.modify',
            SelectableItemSettingsEnum.MODIFY,
              Icons.article
          ),
          countableMenuItemScreen(
            context,
            'general.share',
            SelectableItemSettingsEnum.SHARE,
            Icons.share
          ),
          this.withRedirectUrl ?
          countableMenuItemScreen(
            context,
            'recipe.show_site',
            SelectableItemSettingsEnum.REDIRECT_URL,
            Icons.settings_cell
          ) :
          null,
          countableMenuItemScreen(
            context,
            'general.delete',
            SelectableItemSettingsEnum.DELETE,
            Icons.delete
          ),
        ],
        icon: const Icon(Icons.settings),
        onSelected: (action) {
          callback(action, context, item);
        }
    );
  }
}