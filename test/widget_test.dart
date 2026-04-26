import 'package:flutter_test/flutter_test.dart';

import 'package:event_finder_app/main.dart';

void main() {
  testWidgets('Event Finder home renders', (WidgetTester tester) async {
    await tester.pumpWidget(const EventFinderApp());

    expect(find.text('Event Finder'), findsOneWidget);
    expect(find.text('Nearby Events'), findsOneWidget);
  });
}