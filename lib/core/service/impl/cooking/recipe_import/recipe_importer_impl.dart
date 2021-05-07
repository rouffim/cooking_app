import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/model/recipe/recipe_site_type.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_import/recipe_importer.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_import/recipe_site_importer.dart';
import 'package:cool_cooker/core/service/impl/cooking/recipe_import/recipe_az_importer.dart';
import 'package:cool_cooker/core/service/impl/cooking/recipe_import/recipe_colruyt_importer.dart';
import 'package:cool_cooker/core/service/impl/cooking/recipe_import/recipe_jdf_importer.dart';
import 'package:cool_cooker/core/service/impl/cooking/recipe_import/recipe_marmiton_importer.dart';
import 'package:cool_cooker/core/service/impl/cooking/recipe_import/recipe_s750gr_importer.dart';

class RecipeImporterImpl extends RecipeImporter {
  Map<RecipeSiteType, RecipeSiteImporter> _siteImporters;

  RecipeImporterImpl() {
    _siteImporters = new Map();
    _siteImporters[RecipeSiteType.AZ] = new RecipeAzImporter();
    //_siteImporters[RecipeSiteType.COLRUYT] = new RecipeColruytImporter();
    _siteImporters[RecipeSiteType.JDF] = new RecipeJdfImporter();
    _siteImporters[RecipeSiteType.MARMITON] = new RecipeMarmitonImporter();
    _siteImporters[RecipeSiteType.S750gr] = new RecipeS750grImporter();
  }

  @override
  Recipe importRecipeFromUrl(String url, String body) {
    Recipe recipe;
    RecipeSiteType type = RecipeSiteTypeUtils.urlToType(url);
    RecipeSiteImporter siteImporter = _siteImporters[type];

    if(siteImporter != null) {
      recipe = siteImporter.importRecipeFromUrl(url, body);
    }

    return recipe;
  }


}