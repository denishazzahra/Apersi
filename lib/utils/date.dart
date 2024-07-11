import 'package:intl/intl.dart';

String displayDateString(DateTime date) {
  return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
}

String formattedDateString(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

DateTime parseFromString(String date) {
  return DateFormat('yyyy-MM-dd').parse(date);
}
