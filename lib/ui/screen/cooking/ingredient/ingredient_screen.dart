import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/ui/utils/default_scaffold_screen.dart';
import 'package:flutter/material.dart';


class IngredientScreen extends DefaultScaffoldScreen {
  final int ingredientIndex;

  IngredientScreen(this.ingredientIndex): super();

  @override
  Widget scaffoldBuild(BuildContext context) {
    return Center();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.settings),
        tooltip: AppLocalizations.of(context).getMessage('settings.title'),
        onPressed: () {

        },
      ),
    ];
  }
}
