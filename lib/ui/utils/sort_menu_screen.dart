import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/app_sorting.dart';
import 'package:cool_cooker/ui/utils/sort_menu_item_screen.dart';
import 'package:flutter/material.dart';

class SortMenuScreen extends StatelessWidget {
  final Function callback;

  SortMenuScreen(this.callback);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortEnum>(
        itemBuilder: (BuildContext bc) =>
        [
          sortMenuItemScreen(
              context,
              AppLocalizations.of(context).getMessage('sort.asc.name'),
              SortEnum.NAME_ASC
          ),
          sortMenuItemScreen(
            context,
            AppLocalizations.of(context).getMessage('sort.desc.name'),
            SortEnum.NAME_DESC,
            false,
          ),
          sortMenuItemScreen(
              context,
              AppLocalizations.of(context).getMessage(
                  'sort.desc.modification_date'),
              SortEnum.MODIFICATION_DATE_DESC
          ),
          sortMenuItemScreen(
            context,
            AppLocalizations.of(context).getMessage(
                'sort.asc.modification_date'),
            SortEnum.MODIFICATION_DATE_ASC,
            false,
          ),
          sortMenuItemScreen(
            context,
            AppLocalizations.of(context).getMessage('sort.desc.popularity'),
            SortEnum.POPULARITY_DESC,
          ),
          sortMenuItemScreen(
            context,
            AppLocalizations.of(context).getMessage('sort.asc.popularity'),
            SortEnum.POPULARITY_ASC,
            false,
          ),
        ],
        icon: const Icon(Icons.sort),
        onSelected: (action) {
          callback(action);
        }
    );
  }
}