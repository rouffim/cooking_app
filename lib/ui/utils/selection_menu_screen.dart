import 'package:cool_cooker/ui/enums/selectable_item_settings_enum.dart';
import 'package:cool_cooker/ui/provider/selectable_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectableMenuScreen<T extends SelectableProvider> extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<T>().isSelectionOn,
      child: Column(
        children: [
           Container(
            decoration: BoxDecoration(color: Colors.red),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // IconButton(
                //   icon: Icon(Icons.share),
                //   onPressed: () {
                //     context.read<T>().doAction(SelectableItemSettingsEnum.SHARE, context);
                //   },
                // ),
                Visibility(
                  visible: context.watch<T>().selectedElements.length == 1,
                  child: IconButton(
                    icon: Icon(Icons.article),
                    onPressed: () {
                      context.read<T>().doAction(SelectableItemSettingsEnum.MODIFY, context);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    context.read<T>().doAction(SelectableItemSettingsEnum.DELETE, context);
                  },
                ),
                Text('|'),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    context.read<T>().unSelectAll();
                  },
                ),
              ],
            )
        ),
        Divider(
          color: Colors.white,
          height: 4,
        ),
      ]
      ),
    );
  }
}
