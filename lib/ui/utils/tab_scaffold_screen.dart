import 'package:cool_cooker/ui/provider/selectable_provider.dart';
import 'package:cool_cooker/ui/utils/default_scaffold_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class TabScaffoldScreen<T extends SelectableProvider> extends DefaultScaffoldScreen {
  final int length;

  TabScaffoldScreen({this.length, title}): super(title: title);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: length,
        child:  Builder(builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            context.read<T>().unSelectAll();
          });
          return Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  tabs: buildTabs(context),
                ),
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
      )
    );
  }

  List<Widget> buildTabs(BuildContext context) {
    return new List();
  }
}