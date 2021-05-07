class DateUtils {

  static String nowToString() {
    DateTime date = DateTime.now();

    String day = date.day.toString();
    String month = date.month.toString();

    return (day.length == 1 ? '0' : '') + day + "/" +
        (month.length == 1 ? '0' : '') +  month + "/" +
        date.year.toString();
  }

}