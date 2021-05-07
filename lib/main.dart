import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/app_localizations_delegate.dart';
import 'package:cool_cooker/locators_setup.dart';
import 'package:cool_cooker/ui/provider/cooking/ingredient_form_provider.dart';
import 'package:cool_cooker/ui/provider/cooking/instruction_form_provider.dart';
import 'package:cool_cooker/ui/provider/cooking/recipe_form_provider.dart';
import 'package:cool_cooker/ui/provider/cooking/cooking_provider.dart';
import 'package:cool_cooker/ui/provider/cooking/recipe_provider.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_item_form_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_form_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_list_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_provider.dart';
import 'package:cool_cooker/ui/provider/shopping/shopping_recipe_form_provider.dart';
import 'package:cool_cooker/ui/screen/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/localization/form_builder_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  locatorsSetup();
  runApp(CookingApp());
}

class CookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => NavigatorProvider()),
        ChangeNotifierProvider(create: (context) => RecipeFormProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingListFormProvider()),
        ChangeNotifierProvider(create: (context) => IngredientFormProvider()),
        ChangeNotifierProvider(create: (context) => InstructionFormProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingItemFormProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingRecipeFormProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingProvider()),
        ChangeNotifierProvider(create: (context) => CookingProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (context) => RecipeProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).getMessage('app.title'),
        home: HomePage(),
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey[800],
          accentColor: Colors.cyan[600],

          // Define the default font family.
          fontFamily: "Times New Roman",

          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
