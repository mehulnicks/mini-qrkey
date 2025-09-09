import 'package:flutter_test/flutter_test.dart';
import 'package:qsr_flutter_app/app.dart';

void main() {
  testWidgets('App should render correctly', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.byType(App), findsOneWidget);
    // Add more widget tests as needed
  });
}