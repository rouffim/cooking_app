import 'package:cool_cooker/ui/provider/common_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarBrowseScreen<T extends CommonProvider> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(builder: (context, model, child) {
      return IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.search),
        color: Colors.white,
        onPressed: () {
          model.search();
        },
      );
    });
  }
}