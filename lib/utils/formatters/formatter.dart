import 'package:intl/intl.dart';

class SFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd--MMM-yyyy').format(date);
  }

  // Customize the currency locale and symbole as needed
  
  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }
}
