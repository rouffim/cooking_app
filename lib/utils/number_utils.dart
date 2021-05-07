
import 'dart:math';

class NumberUtils {
  static Random _random = new Random();

  static double transformNumberFromStringToDouble(String number) {
    if(number.contains('/')) {
      List<String> splittedFraction = number.split('/');
      return int.tryParse(splittedFraction[0]) / int.tryParse(splittedFraction[1]);
    }

    number = number.replaceAll(',', '.');
    return double.tryParse(number);
  }

  static bool intIsBlank(int number) {
    return number == null || number == 0;
  }

  static bool intIsNotBlank(int number) {
    return number != null && number != 0;
  }

  static bool doubleIsBlank(double number) {
    return number == null || number == 0;
  }

  static bool doubleIsNotBlank(double number) {
    return number != null && number != 0;
  }

  static double roundDouble(double number, int places){
    double mod = pow(10.0, places);
    return ((number * mod).round().toDouble() / mod);
  }

  static String removeDecimalZeroFormat(double number) {
    return number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 2);
  }

  static int randomInt(int min, int max) {
    return _random.nextInt(max + 1 - min) + min;
  }

  static double randomDouble(int min, int max) {
    return _random.nextDouble() * (max - min) + min;
  }

  static bool checkLimits(int from, int to) {
    return (from == null || from >= 0) && (to == null || to > from);
  }

  static bool checkLimitsNotNull(int from, int to) {
    return from != null && from >= 0 && to != null && to > from;
  }

  static double parseDouble(dynamic toParse) {
    return toParse != null ? double.parse('${toParse}') : null;
  }

  static int parseInt(dynamic toParse) {
    return toParse != null ? int.parse('${toParse}') : null;
  }

  static String doubleToString(double number) {
    if(doubleIsNotBlank(number)) {
      String val = number.toString();
      if(val.endsWith('.0')) {
        val = val.substring(0, val.length - 2);
      }
      return val;
    }
    return null;
  }

  static String intToString(int number) {
    if(intIsNotBlank(number)) {
      return number.toString();
    }
    return null;
  }

}