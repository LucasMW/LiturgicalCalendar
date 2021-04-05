import 'package:flutter_test/flutter_test.dart';

import 'package:liturgical_calendar/main.dart';

void main() {
  testWidgets('Cvt', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
  });
}
