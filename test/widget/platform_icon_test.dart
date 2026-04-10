import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamili_social/widgets/post/platform_icon.dart';

void main() {
  Widget buildTestWidget(String platform, {double size = 24}) {
    return MaterialApp(
      home: Scaffold(body: PlatformIcon(platform: platform, size: size)),
    );
  }

  group('PlatformIcon', () {
    testWidgets('renders facebook icon', (tester) async {
      await tester.pumpWidget(buildTestWidget('facebook'));
      expect(find.byType(PlatformIcon), findsOneWidget);
    });

    testWidgets('renders instagram icon', (tester) async {
      await tester.pumpWidget(buildTestWidget('instagram'));
      expect(find.byType(PlatformIcon), findsOneWidget);
    });

    testWidgets('renders with custom size', (tester) async {
      await tester.pumpWidget(buildTestWidget('twitter', size: 48));
      expect(find.byType(PlatformIcon), findsOneWidget);
    });

    testWidgets('renders unknown platform gracefully', (tester) async {
      await tester.pumpWidget(buildTestWidget('unknown'));
      expect(find.byType(PlatformIcon), findsOneWidget);
    });
  });
}
