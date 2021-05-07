import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/ui/provider/selectable_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectableItemScreen<T extends SelectableProvider> extends StatelessWidget {
  final Widget child;
  final AbstractModel item;
  final Function selectAction;

  SelectableItemScreen({this.child, this.item, this.selectAction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Container(
            decoration: item != null && item.isSelected ? BoxDecoration(color: Colors.red) : null,
            child: child,
          ),
          Divider(
            color: Colors.white,
            height: 4,
          )
        ]
      ),
      onTap: () {
        if(context.read<T>().isSelectionOn){
          context.read<T>().select(item, true);
        } else if(selectAction != null) {
          selectAction();
        }
      },
      onLongPress: () {
        context.read<T>().select(item);
      },
      onDoubleTap: () {
        context.read<T>().select(item);
      },
    );
  }
}
