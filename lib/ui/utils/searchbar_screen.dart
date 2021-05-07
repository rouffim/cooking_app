import 'package:cool_cooker/ui/provider/common_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarScreen<T extends CommonProvider> extends StatelessWidget {
  final String hintText;

  SearchBarScreen(this.hintText);

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(builder: (context, model, child) {
      return Expanded(
          child:
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: TextField(
                controller: model.searchController,
                autofocus: false,
                onSubmitted: (value) {
                  model.search(value);
                },
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  hintText: hintText,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        model.clearSearchBar(),
                    icon: Icon(Icons.clear),
                  ),
                ),
                textInputAction: TextInputAction.search,
              ),
            ),
        );
    });
  }
}
