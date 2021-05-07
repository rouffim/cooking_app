class ListUtils {

  static replace(List list, element) {
    if(list != null && element != null) {
      int index = list.indexOf(element);
      list.removeAt(index);
      list.insert(index, element);
    }
  }

}