import 'package:flutter/material.dart';

import 'date_formatter.dart';

/// Shows the material date picker with safe bounds.
///
/// By default dates range from today until one year ahead.
Future<DateTime?> pickDate(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final today = DateFormatter.today();
  final first = firstDate ?? today;
  var last = lastDate ?? today.add(const Duration(days: 365));
  if (last.isBefore(first)) last = first;

  var initial = initialDate ?? first;
  if (initial.isBefore(first)) initial = first;
  if (initial.isAfter(last)) initial = last;

  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: first,
    lastDate: last,
  );
}
