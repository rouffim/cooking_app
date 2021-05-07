import 'package:cool_cooker/utils/string_utils.dart';

enum RecipeSiteType {
  AZ,
  //COLRUYT,
  JDF,
  MARMITON,
  S750gr,
  NONE
}

class RecipeSiteTypeUtils {
  static const String URL_AZ = 'cuisineaz.com';
  static const String URL_COLRUYT = 'colruyt.be';
  static const String URL_JDF = 'cuisine.journaldesfemmes.fr';
  static const String URL_MARMITON = 'marmiton.org';
  static const String URL_S750gr = '750g.com';

  static RecipeSiteType urlToType(String url) {
    url = StringUtils.urlToDomain(url);
    switch(url) {
      case URL_AZ:
        return RecipeSiteType.AZ;
      //case URL_COLRUYT:
        //return RecipeSiteType.COLRUYT;
      case URL_JDF:
        return RecipeSiteType.JDF;
      case URL_MARMITON:
        return RecipeSiteType.MARMITON;
      case URL_S750gr:
        return RecipeSiteType.S750gr;
      default :
        return RecipeSiteType.NONE;
    }
  }

  static String typeToUrl(RecipeSiteType type) {
    switch(type) {
      case RecipeSiteType.AZ:
        return URL_AZ;
      //case RecipeSiteType.COLRUYT:
        //return URL_COLRUYT;
      case RecipeSiteType.JDF:
        return URL_JDF;
      case RecipeSiteType.MARMITON:
        return URL_MARMITON;
      case RecipeSiteType.S750gr:
        return URL_S750gr;
      case RecipeSiteType.NONE:
        return null;
    }
  }

  static List<RecipeSiteType> getEffectiveTypes() {
    List<RecipeSiteType> types = RecipeSiteType.values.toList();
    types.removeAt(types.length - 1);
    return types;
  }
}