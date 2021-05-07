import 'package:cool_cooker/app_localizations.dart';
import 'package:flutter/material.dart';

abstract class DefaultScaffoldScreen extends StatelessWidget {
  final String title;

  DefaultScaffoldScreen({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle(context)),
        actions: buildActions(context),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return scaffoldBuild(context);
        }
      ),
      floatingActionButton: buildFloatingActionButton(context)
    );
  }

  Widget scaffoldBuild(BuildContext context);

  String screenTitle(BuildContext context) {
    return AppLocalizations.of(context).getMessageOrDefault(title, 'default.scaffold.title');
  }

  List<Widget> buildActions(BuildContext context) {
    return new List();
  }

  Widget buildFloatingActionButton(BuildContext context){
    return null;
  }
}