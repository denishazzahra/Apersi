import 'package:intl/intl.dart';

String displayDateString(DateTime date) {
  return DateFormat('E, MMM d yyyy').format(date);
}

String formattedDateString(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}
