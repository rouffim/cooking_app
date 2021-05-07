import 'package:cool_cooker/core/model/app_sorting.dart';
import 'package:flutter/material.dart';

Widget sortMenuItemScreen(BuildContext context, String title, SortEnum sort, [bool isAsc = true]) {
  return PopupMenuItem(
    child: Row(
        children: [
          Text(title),
          Icon(isAsc ? Icons.north : Icons.south),
        ]
    ),
    value: sort,
  );
}
