import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

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
        return NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(double.parse(currency));
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

    static double? toDouble(String s) {
        if(s.contains(",")){
            s = s.replaceAll(".", ".");
        }
        return double.tryParse(s);
    }

    String getRandomString(int length) {
        Random rnd = Random();
        return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(rnd.nextInt(_chars.length))));
    }

    static DateTime getDatetime(String value) {
        return DateTime.parse(value);
    }

    static String getStringIso(DateTime date) {
        return  DateFormat('yyyy-MM-ddTHH:mm:ssZ','en-US').format(date);
    }
}
