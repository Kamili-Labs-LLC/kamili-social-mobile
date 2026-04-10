import 'package:flutter_test/flutter_test.dart';
import 'package:kamili_social/models/account.dart';
import 'package:kamili_social/models/post.dart';
import 'package:kamili_social/models/brand.dart';
import 'package:kamili_social/models/error_response.dart';
import 'package:kamili_social/models/page_info.dart';

void main() {
  group('Account', () {
    test('fromJson creates account', () {
      final json = {
        'id': '123',
        'name': 'Test User',
        'email': 'test@example.com',
        'plan': 'FREE',
        'selectedTimezone': 'America/New_York',
      };
      final account = Account.fromJson(json);
      expect(account.id, '123');
      expect(account.name, 'Test User');
      expect(account.email, 'test@example.com');
      expect(account.plan, 'FREE');
    });

    test('toJson roundtrips', () {
      final json = {
        'id': '123',
        'name': 'Test',
        'email': 'test@test.com',
        'plan': 'SOLO',
      };
      final account = Account.fromJson(json);
      final output = account.toJson();
      expect(output['id'], '123');
      expect(output['name'], 'Test');
    });
  });

  group('Post', () {
    test('fromJson creates post', () {
      final json = {
        'id': 'post-1',
        'status': 'DRAFT',
        'content': {
          'default': {'text': 'Hello world'},
        },
        'targetConnectionIds': ['conn-1'],
        'createdAt': '2026-04-10T12:00:00Z',
      };
      final post = Post.fromJson(json);
      expect(post.id, 'post-1');
      expect(post.status, 'DRAFT');
    });

    test('handles null fields gracefully', () {
      final json = {'id': 'post-2', 'status': 'SCHEDULED'};
      final post = Post.fromJson(json);
      expect(post.id, 'post-2');
      expect(post.scheduledAt, isNull);
    });
  });

  group('Brand', () {
    test('fromJson creates brand', () {
      final json = {
        'id': 'brand-1',
        'name': 'My Brand',
        'isActive': true,
      };
      final brand = Brand.fromJson(json);
      expect(brand.id, 'brand-1');
      expect(brand.name, 'My Brand');
    });
  });

  group('ErrorResponse', () {
    test('fromJson parses error', () {
      final json = {'errorCode': 401, 'message': 'Unauthorized'};
      final error = ErrorResponse.fromJson(json);
      expect(error.errorCode, 401);
      expect(error.message, 'Unauthorized');
    });
  });

  group('PageInfo', () {
    test('fromJson with defaults', () {
      final pageInfo = PageInfo.fromJson({});
      expect(pageInfo.hasNextPage, false);
      expect(pageInfo.totalItems, isNull);
    });

    test('fromJson with values', () {
      final pageInfo = PageInfo.fromJson({
        'hasNextPage': true,
        'totalItems': 42,
      });
      expect(pageInfo.hasNextPage, true);
      expect(pageInfo.totalItems, 42);
    });
  });

  group('AuthException', () {
    test('toString includes code and message', () {
      final e = AuthException(401, 'Unauthorized');
      expect(e.toString(), contains('401'));
      expect(e.toString(), contains('Unauthorized'));
    });
  });
}
