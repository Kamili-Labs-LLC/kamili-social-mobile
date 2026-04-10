import 'package:intl/intl.dart';

class DateFormatters {
  DateFormatters._();

  static final _fullDate = DateFormat('MMM d, yyyy');
  static final _shortDate = DateFormat('MMM d');
  static final _time = DateFormat('h:mm a');
  static final _dateTime = DateFormat('MMM d, yyyy h:mm a');
  static final _dayMonth = DateFormat('EEE, MMM d');
  static final _monthYear = DateFormat('MMMM yyyy');

  static String fullDate(DateTime date) => _fullDate.format(date);
  static String shortDate(DateTime date) => _shortDate.format(date);
  static String time(DateTime date) => _time.format(date);
  static String dateTime(DateTime date) => _dateTime.format(date);
  static String dayMonth(DateTime date) => _dayMonth.format(date);
  static String monthYear(DateTime date) => _monthYear.format(date);

  static String relative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return fullDate(date);
  }

  static String scheduledLabel(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == DateTime(now.year, now.month, now.day)) {
      return 'Today at ${time(date)}';
    }
    if (dateOnly == tomorrow) {
      return 'Tomorrow at ${time(date)}';
    }
    return '${dayMonth(date)} at ${time(date)}';
  }

  static DateTime? tryParse(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    return DateTime.tryParse(dateString);
  }
}
