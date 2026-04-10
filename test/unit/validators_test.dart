import 'package:flutter_test/flutter_test.dart';
import 'package:kamili_social/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error for empty string', () {
      expect(Validators.email(''), isNotNull);
    });

    test('returns error for null', () {
      expect(Validators.email(null), isNotNull);
    });

    test('returns error for invalid email', () {
      expect(Validators.email('notanemail'), isNotNull);
      expect(Validators.email('missing@'), isNotNull);
      expect(Validators.email('@missing.com'), isNotNull);
    });

    test('returns null for valid email', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('test.user@domain.co'), isNull);
    });
  });

  group('Validators.password', () {
    test('returns error for empty', () {
      expect(Validators.password(''), isNotNull);
    });

    test('returns error for short password', () {
      expect(Validators.password('abc'), isNotNull);
    });

    test('returns null for valid password', () {
      expect(Validators.password('12345678'), isNull);
    });
  });

  group('Validators.strongPassword', () {
    test('requires uppercase', () {
      expect(Validators.strongPassword('abcdefg1'), isNotNull);
    });

    test('requires lowercase', () {
      expect(Validators.strongPassword('ABCDEFG1'), isNotNull);
    });

    test('requires number', () {
      expect(Validators.strongPassword('Abcdefgh'), isNotNull);
    });

    test('accepts strong password', () {
      expect(Validators.strongPassword('Abcdefg1'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('returns error when passwords dont match', () {
      expect(Validators.confirmPassword('abc', 'def'), isNotNull);
    });

    test('returns null when passwords match', () {
      expect(Validators.confirmPassword('Test123!', 'Test123!'), isNull);
    });
  });

  group('Validators.passwordStrength', () {
    test('returns 0 for empty', () {
      expect(Validators.passwordStrength(''), 0);
    });

    test('returns 1 for length only', () {
      expect(Validators.passwordStrength('12345678'), greaterThanOrEqualTo(1));
    });

    test('returns 4 for strong password', () {
      expect(Validators.passwordStrength('Abcdefg1'), 4);
    });

    test('labels are correct', () {
      expect(Validators.passwordStrengthLabel(0), '');
      expect(Validators.passwordStrengthLabel(1), 'Weak');
      expect(Validators.passwordStrengthLabel(2), 'Fair');
      expect(Validators.passwordStrengthLabel(3), 'Good');
      expect(Validators.passwordStrengthLabel(4), 'Strong');
    });
  });

  group('Validators.required', () {
    test('returns error for empty', () {
      expect(Validators.required(''), isNotNull);
      expect(Validators.required(null), isNotNull);
      expect(Validators.required('   '), isNotNull);
    });

    test('returns null for non-empty', () {
      expect(Validators.required('hello'), isNull);
    });
  });
}
