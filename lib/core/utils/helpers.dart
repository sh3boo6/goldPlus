import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'ar_SA',
      symbol: 'ر.س',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd - hh:mm a', 'ar').format(date);
  }

  static double getKaratPurity(int karat) {
    switch (karat) {
      case 24:
        return 1.0;
      case 22:
        return 22 / 24;
      case 21:
        return 21 / 24;
      case 18:
        return 18 / 24;
      default:
        return 1.0;
    }
  }
}