import 'package:cool_cooker/ui/provider/cooking/recipe_provider.dart';
import 'package:cool_cooker/ui/screen/cooking/instruction/instruction_list_screen.dart';
import 'package:cool_cooker/ui/utils/empty_list_message_screen.dart';
import 'package:cool_cooker/ui/utils/progress_container_screen.dart';
import 'package:cool_cooker/ui/utils/selection_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstructionsListScreen extends StatefulWidget {
  @override
  _InstructionsListScreenState createState() => _InstructionsListScreenState();
}

class _InstructionsListScreenState extends State<InstructionsListScreen>
    with AutomaticKeepAliveClientMixin<InstructionsListScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return context.watch<RecipeProvider>().recipe == null ? ProgressContainerScreen() : Container(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: context.watch<RecipeProvider>().recipe.instructions.isEmpty ?
          EmptyListMessageScreen('recipe.instructions.list.empty') :
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableMenuScreen<RecipeProvider>(),
              Flexible(
                  child: ListView.builder(
                    // Let the ListView know how many items it needs to build.
                    itemCount: context.watch<RecipeProvider>().recipe.instructions.length + 1,
                    // Provide a builder function. This is where the magic happens.
                    // Convert each item into a widget based on the type of item it is.
                    itemBuilder: (context, index) {
                      if(index == context.watch<RecipeProvider>().recipe.instructions.length) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 270,
                        );
                      }
                      return InstructionListScreen<RecipeProvider>(
                          context.watch<RecipeProvider>().recipe.instructions.elementAt(index)
                      );
                    },
                  )
              )
            ]
      )
    );
  }
}