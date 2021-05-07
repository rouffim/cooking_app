import 'package:cool_cooker/core/model/recipe/recipe_site_type.dart';
import 'package:cool_cooker/ui/provider/navigator_provider.dart';
import 'package:cool_cooker/ui/utils/default_scaffold_screen.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CompatibleRecipeWebsitesScreen extends DefaultScaffoldScreen {

  CompatibleRecipeWebsitesScreen(): super(title: 'home.compatible_websites');

  @override
  Widget scaffoldBuild(BuildContext context) {
    List types = RecipeSiteTypeUtils.getEffectiveTypes();
    return ListView.builder(
      itemCount: types.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        var type = types.elementAt(index);
        String name = RecipeSiteTypeUtils.typeToUrl(type);

        return _compatibleRecipeWebsite(
          context,
          name,
          StringUtils.domainToUrl(name)
        );
      },
    );
  }

  Widget _compatibleRecipeWebsite(BuildContext context, String title, String url) {
    return Column(
      children: [
        InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: LimitedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.4, // the height between text, default is null
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Icon(
                        Icons.chevron_right
                      ),
                    ),
                  ],
                )
            )
          ),
          onTap: () async {
            Provider.of<NavigatorProvider>(context, listen: false).launchUrl(url);
          },
        ),
        Divider(
          color: Colors.white,
          height: 4,
        )
      ]
    );
  }
}
