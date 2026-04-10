import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamili_social/widgets/post/post_status_badge.dart';

void main() {
  Widget buildTestWidget(String status) {
    return MaterialApp(
      home: Scaffold(body: PostStatusBadge(status: status)),
    );
  }

  group('PostStatusBadge', () {
    testWidgets('shows DRAFT label', (tester) async {
      await tester.pumpWidget(buildTestWidget('DRAFT'));
      expect(find.text('Draft'), findsOneWidget);
    });

    testWidgets('shows SCHEDULED label', (tester) async {
      await tester.pumpWidget(buildTestWidget('SCHEDULED'));
      expect(find.text('Scheduled'), findsOneWidget);
    });

    testWidgets('shows PUBLISHED label', (tester) async {
      await tester.pumpWidget(buildTestWidget('PUBLISHED'));
      expect(find.text('Published'), findsOneWidget);
    });

    testWidgets('shows FAILED label', (tester) async {
      await tester.pumpWidget(buildTestWidget('FAILED'));
      expect(find.text('Failed'), findsOneWidget);
    });

    testWidgets('shows PENDING_APPROVAL label', (tester) async {
      await tester.pumpWidget(buildTestWidget('PENDING_APPROVAL'));
      expect(find.text('Pending'), findsOneWidget);
    });
  });
}
