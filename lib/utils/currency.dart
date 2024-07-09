import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  var formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return formatter.format(amount);
}
