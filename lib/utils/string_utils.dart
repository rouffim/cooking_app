import 'package:cool_cooker/utils/number_utils.dart';
import 'package:faker/faker.dart';
import 'package:validators/validators.dart';

class StringUtils {
  static Faker _faker = new Faker();

  static List<String> splitFirst(String str, String separator) {
    if(isNotBlank(str)) {
      int index = str.indexOf(separator);
      if(index >= 0) {
        return [
          str.substring(0, index),
          str.substring(index + separator.length)
        ];
      }
    }

    return new List();
  }

  static List<String> splitLast(String str, String separator) {
    if(isNotBlank(str)) {
      int index = str.lastIndexOf(separator);
      return [str.substring(0, index), str.substring(index + separator.length)];
    }

    return new List();
  }

  static bool isBlank(String str) {
    return str == null || str.isEmpty;
  }

  static bool isNotBlank(String str) {
    return str != null && str.isNotEmpty;
  }

  static String replaceMalformedHtmlTags(String html) {
    html = StringUtils.replaceMalformedHtmlTag(html, 'li');

    return html;
  }

  static String replaceMalformedHtmlTag(String html, String tagName) {
    return html.replaceAll("<$tagName >", '<$tagName>').replaceAll("< $tagName>", '<$tagName>').replaceAll("< $tagName >", '<$tagName>');
  }

  static String toDisplayableString(String str) {
    if(isBlank(str)) {
      return '[Empty String]';
    }
    return str;
  }

  static String urlToDomain(String url) {
    if(url.contains('://')) {
      url = splitFirst(url, '://')[1];
    }
    if(url.startsWith('www.')) {
      url = splitFirst(url, 'www.')[1];
    }
    if(url.contains('/')) {
      url = splitFirst(url, '/')[0];
    }

    return url;
  }

  static String domainToUrl(String domain, [bool https = true]) {
    return "http" + (https ? "s" : "") + "://" + domain;
  }

  static bool isUrl(String str) {
    return isURL(str);
  }

  static bool isString(str) {
    return str is String;
  }

  static String generateWordString() {
    return faker.lorem.word();
  }

  static String generateShortString() {
    return faker.lorem.words(NumberUtils.randomInt(1, 5)).join(' ');
  }

  static String generateMediumString() {
    return faker.lorem.words(NumberUtils.randomInt(4, 10)).join(' ');
  }

  static String generateLongString() {
    return faker.lorem.sentences(NumberUtils.randomInt(1, 4)).join('. ');
  }

  static String generateFakeEmail() {
    return faker.internet.email();
  }

  static String generateFakeUrl() {
    return faker.internet.httpsUrl();
  }

  static String cleanString(String str) {
    str = str.trim();

    if(str.startsWith('"')) {
      str = str.substring(1);
    }

    if(str.endsWith('"')) {
      str = str.substring(0, str.length - 1);
    }

    return str.trim();
  }

  static String removeStartNumber(String str) {
    if(str.startsWith(new RegExp(r'[0-9]')) && str.contains(' ')) {
      str = StringUtils.splitFirst(str, ' ')[1];
    }
    return str;
  }

  static String toFormTitle(String title, String uuid) {
    if(title.endsWith('form.title')) {
      List<String> parts = splitLast(title, 'form.title');
      return parts[0] + "form." + (isBlank(uuid) ? "add" : "modify") + ".title";
    }

    return title;
  }
}