import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  return "${date.day}.${date.month}.${date.year}";
}

Color priorityColor(int priority) {
  switch (priority) {
    case 3:
      return Colors.red;
    case 2:
      return Colors.orange;
    default:
      return Colors.green;
  }
}
