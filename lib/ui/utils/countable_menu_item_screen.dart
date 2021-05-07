import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/ui/enums/selectable_item_settings_enum.dart';
import 'package:flutter/material.dart';

Widget countableMenuItemScreen(BuildContext context, String title, SelectableItemSettingsEnum sort, [IconData icon]) {
  return PopupMenuItem(
    child: Row(
        children: [
          icon != null ? Icon(icon) : SizedBox(),
          icon != null ? SizedBox(width: 10) : SizedBox(),
          Text(AppLocalizations.of(context).getMessage(title)),
        ]
    ),
    value: sort,
  );
}
