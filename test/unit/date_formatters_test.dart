import 'package:flutter_test/flutter_test.dart';
import 'package:kamili_social/utils/date_formatters.dart';

void main() {
  group('DateFormatters', () {
    test('fullDate formats correctly', () {
      final date = DateTime(2026, 4, 10);
      expect(DateFormatters.fullDate(date), 'Apr 10, 2026');
    });

    test('shortDate formats correctly', () {
      final date = DateTime(2026, 12, 25);
      expect(DateFormatters.shortDate(date), 'Dec 25');
    });

    test('time formats correctly', () {
      final date = DateTime(2026, 4, 10, 14, 30);
      expect(DateFormatters.time(date), contains('2:30'));
    });

    test('relative shows just now for recent times', () {
      final now = DateTime.now();
      expect(DateFormatters.relative(now), 'Just now');
    });

    test('relative shows minutes', () {
      final fiveMinAgo = DateTime.now().subtract(const Duration(minutes: 5));
      expect(DateFormatters.relative(fiveMinAgo), '5m ago');
    });

    test('relative shows hours', () {
      final threeHoursAgo = DateTime.now().subtract(const Duration(hours: 3));
      expect(DateFormatters.relative(threeHoursAgo), '3h ago');
    });

    test('relative shows days', () {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      expect(DateFormatters.relative(twoDaysAgo), '2d ago');
    });

    test('tryParse handles null', () {
      expect(DateFormatters.tryParse(null), isNull);
      expect(DateFormatters.tryParse(''), isNull);
    });

    test('tryParse handles valid date', () {
      expect(DateFormatters.tryParse('2026-04-10T12:00:00Z'), isNotNull);
    });

    test('scheduledLabel shows Today', () {
      final today = DateTime.now().copyWith(hour: 15, minute: 0);
      final label = DateFormatters.scheduledLabel(today);
      expect(label, startsWith('Today'));
    });
  });
}
