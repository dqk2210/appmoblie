import 'package:intl/intl.dart';

class CurrencyFormat {
  static String formatVND(double amount) {
    // Định dạng kiểu: 100.000 đ
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(amount);
  }

  static String formatDate(String dateStr) {
    if (dateStr.isEmpty) return '--/--/----';
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (e) {
      return dateStr;
    }
  }
}
