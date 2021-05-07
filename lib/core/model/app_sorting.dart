enum SortEnum {
  NAME_ASC,
  NAME_DESC,
  MODIFICATION_DATE_ASC,
  MODIFICATION_DATE_DESC,
  POPULARITY_ASC,
  POPULARITY_DESC,
  FAVORITE,
}

class SortUtils {

  static String enumToKey(SortEnum sortEnum) {
    switch(sortEnum) {
      case SortEnum.NAME_ASC:
      case SortEnum.NAME_DESC:
        return 'name';
      case SortEnum.MODIFICATION_DATE_ASC:
      case SortEnum.MODIFICATION_DATE_DESC:
        return 'last_modification_date';
      case SortEnum.POPULARITY_ASC:
      case SortEnum.POPULARITY_DESC:
        return 'views';
      case SortEnum.FAVORITE:
        return 'is_favorite';
      default :
        return null;
    }
  }

  static bool isEnumAsc(SortEnum sortEnum) {
    switch(sortEnum) {
      case SortEnum.NAME_ASC:
      case SortEnum.MODIFICATION_DATE_ASC:
      case SortEnum.POPULARITY_ASC:
      case SortEnum.FAVORITE:
        return true;
      default :
        return false;
    }
  }
}