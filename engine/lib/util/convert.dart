// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class Convert {
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  /// It takes a hexadecimal string and converts it to a color
  ///
  /// Args:
  ///   code (String): The hex code of the color.
  ///
  /// Returns:
  ///   A color object.
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  /// It takes a currency value, a currency symbol, and a grouping symbol, and
  /// returns a formatted currency string
  ///
  /// Args:
  ///   currency (String): The currency value to be formatted.
  ///   symbol (String): The currency symbol, e.g. '$'
  ///   grouping (String): The character used to separate thousands.
  ///
  /// Returns:
  ///   A string with the currency symbol and the value of the currency.
  static String toCurrency(String currency, String symbol, String? grouping) {
    // var controller = MoneyMaskedTextController(thousandSeparator: grouping);
    // controller.updateValue(double.parse(currency));

    // return '$symbol ${controller.text.substring(0, controller.text.length - 3)}';

    // final oCcy = new NumberFormat("#.##0,00");
    // String converted = oCcy.format(double.parse(currency));
    return NumberFormat.currency(locale: 'id', symbol: symbol, decimalDigits: 2).format(double.parse(currency));
  }

  static String toCurrencyWithoutDecimal(String currency, String symbol, String? grouping) {
    // var controller = MoneyMaskedTextController(thousandSeparator: grouping);
    // controller.updateValue(double.parse(currency));

    // return '$symbol ${controller.text.substring(0, controller.text.length - 3)}';

    // final oCcy = new NumberFormat("#.##0,00");
    // String converted = oCcy.format(double.parse(currency));
    return NumberFormat.currency(locale: 'id', symbol: symbol, decimalDigits: 0).format(double.parse(currency));
  }

  /// It takes a currency value, a currency symbol, a grouping separator, and a
  /// decimal separator, and returns a formatted currency string
  ///
  /// Args:
  ///   currency (String): The currency value to be formatted.
  ///   symbol (String): The currency symbol, e.g. $
  ///   grouping (String): The character used to separate thousands.
  ///   decimal (String): The decimal separator.
  ///
  /// Returns:
  ///   A string with the currency symbol and the formatted currency.
  static String toCurrencyWithDecimal(String currency, String symbol, String grouping, String decimal) {
    var controller = MoneyMaskedTextController(decimalSeparator: decimal, thousandSeparator: grouping);
    controller.updateValue(double.parse(currency));

    return '$symbol ${controller.text}';
  }

  static String toCurrencyWithDecimalAndPrecision(String currency, String symbol, String grouping, String decimal, int precision) {
    var controller = MoneyMaskedTextController(decimalSeparator: decimal, thousandSeparator: grouping, precision: precision);
    controller.updateValue(double.parse(currency));

    return '$symbol ${controller.text}';
  }

  /// If the string can be converted to a double, then it is a number
  ///
  /// Args:
  ///   s (String): The string to check.
  ///
  /// Returns:
  ///   A boolean value.
  static bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  /// The function `toDouble` converts a string to a double, replacing any commas
  /// with periods before parsing the string.
  ///
  /// Args:
  ///   s (String): The parameter "s" is a string that represents a number.
  ///
  /// Returns:
  ///   The method is returning a double value.
  static double? toDouble(String s) {
    if (s.contains(",")) {
      s = s.replaceAll(",", ".");
    }
    return double.tryParse(s);
  }

  /// The function getRandomString generates a random string of a specified
  /// length.
  ///
  /// Args:
  ///   length (int): The length parameter specifies the length of the random
  /// string that will be generated.
  ///
  /// Returns:
  ///   a randomly generated string of the specified length.
  String getRandomString(int length) {
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(rnd.nextInt(_chars.length))));
  }

  /// The function `getLocalTime` takes a string representation of a date and
  /// time, and a boolean indicating whether the input is in UTC or local time,
  /// and returns a DateTime object in the local time zone.
  ///
  /// Args:
  ///   value (String): The value parameter is a string representing a date and
  /// time in the format "yyyy-MM-ddTHH:mm:ssZ".
  ///   fromUTC (bool): The "fromUTC" parameter is a boolean value that indicates
  /// whether the input time value is in UTC (Coordinated Universal Time) format
  /// or not. If it is set to true, it means that the input time value is in UTC
  /// format and needs to be converted to the local time zone. If
  ///
  /// Returns:
  ///   The method is returning a DateTime object.
  static DateTime getLocalTime(String value, bool fromUTC) {
    return DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(value, true).toLocal();
  }

  /// The function "getDatetime" takes a string value and returns a DateTime
  /// object by parsing the string.
  ///
  /// Args:
  ///   value (String): The value parameter is a string representation of a date
  /// and time.
  ///
  /// Returns:
  ///   The method is returning a DateTime object.
  static DateTime getDatetime(String value) {
    return DateTime.parse(value);
  }

  /// The function `getStringIso` takes a `DateTime` object and returns a
  /// formatted string representation of the date in ISO 8601 format.
  ///
  /// Args:
  ///   date (DateTime): The parameter "date" is of type DateTime, which
  /// represents a specific point in time.
  ///
  /// Returns:
  ///   The method is returning a string representation of the given DateTime
  /// object in the ISO 8601 format.
  static String getStringIso(DateTime date) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date);
  }

  /// The function returns the day of a given DateTime object as a string, with a
  /// leading zero if the day is less than 10.
  ///
  /// Args:
  ///   dateTime (DateTime): The parameter "dateTime" is of type DateTime, which
  /// represents a specific date and time.
  ///
  /// Returns:
  ///   The method is returning a string representation of the day in the given
  /// DateTime object. If the day is less than 10, it will return a string with a
  /// leading zero, otherwise it will return the string representation of the day
  /// without any leading zero.
  static String getDay(DateTime dateTime) {
    if (dateTime.day < 10) {
      return '0${dateTime.day}';
    } else {
      return '${dateTime.day}';
    }
  }

  /// The function returns the month number of a given DateTime object as a
  /// string, with a leading zero if the month is less than 10.
  ///
  /// Args:
  ///   dateTime (DateTime): The parameter "dateTime" is of type DateTime, which
  /// represents a specific point in time. It contains information about the year,
  /// month, day, hour, minute, second, and millisecond.
  ///
  /// Returns:
  ///   The method is returning a string representation of the month number in the
  /// given DateTime object.
  static String getMonthNumber(DateTime dateTime) {
    if (dateTime.month < 10) {
      return '0${dateTime.month}';
    } else {
      return '${dateTime.month}';
    }
  }

  /// The function "getMonth" takes a DateTime object as input and returns the
  /// corresponding month name in Indonesian language.
  ///
  /// Args:
  ///   dateTime (DateTime): The parameter "dateTime" is of type DateTime and
  /// represents a specific date and time.
  ///
  /// Returns:
  ///   The method is returning the name of the month corresponding to the given
  /// DateTime object.
  static String getMonth(DateTime dateTime) {
    List<String> month = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return month[dateTime.month - 1];
  }

  /// The function "getYear" returns the year of a given DateTime object as a
  /// string.
  ///
  /// Args:
  ///   dateTime (DateTime): The parameter "dateTime" is of type DateTime, which
  /// represents a specific point in time.
  ///
  /// Returns:
  ///   The year of the given DateTime object.
  static String getYear(DateTime dateTime) {
    return '${dateTime.year}';
  }

  /// The function returns the hour of a given DateTime object as a string, with a
  /// leading zero if the hour is less than 10.
  ///
  /// Args:
  ///   dateTime (DateTime): The parameter "dateTime" is of type DateTime, which
  /// represents a specific point in time. It contains information about the year,
  /// month, day, hour, minute, second, and millisecond.
  ///
  /// Returns:
  ///   The method is returning a string representation of the hour component of
  /// the given DateTime object.
  static String getHour(DateTime dateTime) {
    if (dateTime.hour < 10) {
      return '0${dateTime.hour}';
    } else {
      return '${dateTime.hour}';
    }
  }

  /// The function returns the minute of a given DateTime object as a string, with
  /// a leading zero if the minute is less than 10.
  ///
  /// Args:
  ///   dateTime (DateTime): The parameter "dateTime" is of type DateTime, which
  /// represents a specific point in time. It contains information about the year,
  /// month, day, hour, minute, second, and millisecond.
  ///
  /// Returns:
  ///   The method is returning a string representation of the minute value of the
  /// given DateTime object. If the minute value is less than 10, it returns a
  /// string with a leading zero, otherwise it returns the string representation
  /// of the minute value without any modifications.
  static String getMinute(DateTime dateTime) {
    if (dateTime.minute < 10) {
      return '0${dateTime.minute}';
    } else {
      return '${dateTime.minute}';
    }
  }

  /// The function returns the second of a given DateTime object as a string, with
  /// a leading zero if the second is less than 10.
  ///
  /// Args:
  ///   dateTime (DateTime): The parameter "dateTime" is of type DateTime, which
  /// represents a specific point in time.
  ///
  /// Returns:
  ///   The method is returning the second component of the given DateTime object
  /// as a string. If the second is less than 10, it is returned with a leading
  /// zero. Otherwise, it is returned as is.
  static String getSecond(DateTime dateTime) {
    if (dateTime.second < 10) {
      return '0${dateTime.second}';
    } else {
      return '${dateTime.second}';
    }
  }

  /// The function `roundPrice` rounds a given price to the nearest thousand.
  ///
  /// Args:
  ///   price (double): The price is a decimal number representing the cost of an item.
  ///
  /// Returns:
  ///   The code is returning the rounded price as an integer.
  static int roundPrice(double price) {
    if (price % 1000 == 500) {
      return price.toInt();
    } else if (price % 1000 < 500) {
      return (price / 1000).floor() * 1000;
    }
    return (price / 1000).ceil() * 1000;
  }

  static String getDate(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      DateTime dateTime = getDatetime(dateString);
      return '${getYear(dateTime)}-${getMonthNumber(dateTime)}-${getDay(dateTime)}';
    } else {
      return '-';
    }
  }

  static bool isUsePplApps(String userType) {
    return userType == "ppl" || userType == "pembantu umum" || userType == "mitra manager" || userType == "area manager" || userType == "vice president" || userType == "c level";
  }

  static String getRenderTime({required int startTime}) {
    Duration totalTime = DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(startTime * 1000));
    return "${totalTime.inHours} hours : ${totalTime.inMinutes} minutes : ${totalTime.inSeconds} seconds : ${totalTime.inMilliseconds} miliseconds";
  }

  static int getRangeDateToNow(DateTime startDate) {
    Duration totalTime = DateTime.now().difference(startDate);
    return totalTime.inDays;
  }
}
