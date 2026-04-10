import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamili_social/widgets/common/empty_state.dart';

void main() {
  group('EmptyState', () {
    testWidgets('displays title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'No Items',
              subtitle: 'Nothing to show here',
            ),
          ),
        ),
      );
      expect(find.text('No Items'), findsOneWidget);
      expect(find.text('Nothing to show here'), findsOneWidget);
    });

    testWidgets('shows action button when provided', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'Empty',
              actionLabel: 'Add Item',
              onAction: () => tapped = true,
            ),
          ),
        ),
      );
      expect(find.text('Add Item'), findsOneWidget);
      await tester.tap(find.text('Add Item'));
      expect(tapped, true);
    });

    testWidgets('hides action button when not provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'Empty',
            ),
          ),
        ),
      );
      expect(find.byType(ElevatedButton), findsNothing);
    });
  });
}
