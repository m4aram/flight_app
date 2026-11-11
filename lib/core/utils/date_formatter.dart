/// Lightweight date formatting matching the design (e.g. `Sat, 10 Feb`).
abstract final class DateFormatter {
  static const List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// `Sat, 10 Feb`
  static String short(DateTime date) =>
      '${_weekdays[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]}';

  /// `10 Feb 2026`
  static String full(DateTime date) =>
      '${date.day} ${_months[date.month - 1]} ${date.year}';

  /// `10 Feb`
  static String dayMonth(DateTime date) =>
      '${date.day} ${_months[date.month - 1]}';

  /// Removes the time part of [date].
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime today() => dateOnly(DateTime.now());
}
