import 'package:html/dom.dart';

class DomUtils {

  static void removeElement(Element element, String selector) {
    Element elem = element.querySelector(selector);

    if(elem != null) {
      elem.remove();
    }
  }
}