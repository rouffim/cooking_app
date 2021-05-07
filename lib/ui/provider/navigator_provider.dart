import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/ui/provider/cooking/cooking_provider.dart';
import 'package:cool_cooker/ui/provider/cooking/recipe_provider.dart';
import 'package:cool_cooker/ui/provider/navigator_message.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigatorProvider {

  void navigateToPreviousScreen(context, [String message]) {
    Navigator.pop<NavigatorMessage>(context, NavigatorMessage(message));
  }

  void navigateToPreviousScreenWithMessage(context, [String message = "snack.default"]) {
    Navigator.pop<NavigatorMessage>(context, NavigatorMessage(message));
  }

  void navigateToPreviousScreenWithErrorMessage(context, [String message = "snack.error.default"]) {
    Navigator.pop<NavigatorMessage>(context, NavigatorMessage(message, isError: true));
  }

  void navigateTo(Widget widget, context, [Function toCallBefore]) async {
    if(toCallBefore != null) {
      toCallBefore();
    }

    Provider.of<CookingProvider>(context, listen: false).unSelectAll();
    Provider.of<ShoppingProvider>(context, listen: false).unSelectAll();
    Provider.of<RecipeProvider>(context, listen: false).unSelectAll();
    Provider.of<ShoppingListProvider>(context, listen: false).unSelectAll();

    var response = await Navigator.push<NavigatorMessage>(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

    if(response != null) {
      showSnackBar(context, message: response.message, i18n: response.isI18n, isError: response.isError);
    }
  }

  void showSnackBar(context, {String message = "snack.default", bool i18n = true, bool isError = false}) {
    message = i18n ? AppLocalizations.of(context).getMessage(message) : message;

    removeCurrentSnackBar(context);

    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : null,
        content: Text(message)
      )
    );
  }

  void removeCurrentSnackBar(context, { SnackBarClosedReason reason = SnackBarClosedReason.remove }) {
    assert(reason != null);
    Scaffold.of(context).removeCurrentSnackBar(reason: reason);
  }

  void shareContent(String content, [String subject]) {
    Share.share(content, subject: subject);
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
        enableJavaScript: true
      );
    } else {
      print(url + ' unreachable');
    }
  }
}