import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/ui/provider/selectable_provider.dart';
import 'package:cool_cooker/ui/utils/selectable_item_screen.dart';
import 'package:flutter/material.dart';

class InstructionListScreen<T extends SelectableProvider> extends StatelessWidget {
  final Instruction instruction;

  InstructionListScreen(this.instruction);

  @override
  Widget build(BuildContext context) {
    return SelectableItemScreen<T>(
        item: instruction,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: LimitedBox(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        instruction.toString(),
                        style: TextStyle(
                          height: 1.4, // the height between text, default is null
                        )
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }
}