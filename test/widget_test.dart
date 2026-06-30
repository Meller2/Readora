import 'package:flutter_test/flutter_test.dart';
import 'package:readora/main.dart';

void main() {
  testWidgets('Readora opens the library screen', (tester) async {
    await tester.pumpWidget(const ReadoraApp());

    expect(find.text('Readora'), findsOneWidget);
    expect(find.text('Quiet Stars'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
  });
}
