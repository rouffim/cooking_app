import 'package:cool_cooker/app_localizations.dart';
import 'package:flutter/material.dart';


class AlertUtils {
  static Future<void> showConfirmationAlert(BuildContext context, Function callback, {String title, String content}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: title == null ? Text(AppLocalizations.of(context).getMessage('general.confirm')) : Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                content == null ? Text(AppLocalizations.of(context).getMessage('dialog.content.default')) : Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).getMessage('general.cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).getMessage('general.confirm')),
              onPressed: () {
                Navigator.of(context).pop();
                callback();
              },
            ),
          ],
        );
      },
    );
  }

}