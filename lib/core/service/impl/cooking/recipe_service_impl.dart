import 'package:cool_cooker/core/model/exception/default_exception.dart';
import 'package:cool_cooker/core/model/exception/recipe/recipe_import_from_url_exception.dart';
import 'package:cool_cooker/core/model/exception/unreachable_url_exception.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_import/recipe_importer.dart';
import 'package:cool_cooker/core/service/api/cooking/recipe_service.dart';
import 'package:cool_cooker/core/service/impl/cooking/recipe_import/recipe_importer_impl.dart';
import 'package:http/http.dart' as http;

class RecipeServiceImpl extends RecipeService {
  RecipeImporter _importer;

  @override
  Future<Recipe> importRecipeFromURL(String url) async {
    await checkConnectivity();

    var response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        return importer.importRecipeFromUrl(url, response.body);
      } catch(e) {
        print('Import recipe from ' + url + ' failed.');
        print(e.toString());
        throw new RecipeImportFromUrlException();
      }
    } else {
      print('Import recipe from ' + url + ' failed, url not reachable (' + response.statusCode.toString() + ').');
      throw new UnreachableUrlException();
    }
    return null;
  }

  RecipeImporter get importer {
    if(_importer == null) {
      _importer = new RecipeImporterImpl();
    }
    return _importer;
  }
}