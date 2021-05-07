import 'package:cool_cooker/app_localizations.dart';
import 'package:flutter/material.dart';

class EmptyListMessageScreen extends StatelessWidget {
  final String text;
  final bool withTip;

  EmptyListMessageScreen(this.text, [this.withTip = true]);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context).getMessage(text)),
          SizedBox(height: 10),
          Text(withTip ? AppLocalizations.of(context).getMessage('general.list.add.tip') : '')
        ],
      ),
    );
  }
}
